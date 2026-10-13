/*****************************************************************************
 * config_model.cpp : QML configuration model and backend bridge
 *****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "config_model.hpp"

#include <vlc_common.h>
#include <vlc_plugin.h>
#include <vlc_configuration.h>
#include <vlc_config_cat.h>
#include <vlc_modules.h>

ConfigModel::ConfigModel(qt_intf_t *p_intf, QObject *parent)
    : QObject(parent)
    , m_intf(p_intf)
{
}

QVariant ConfigModel::get(const QString &key, const QVariant &fallback) const
{
    QByteArray ba = key.toUtf8();
    const char *name = ba.constData();
    int type = config_GetType(name);
    if (type == 0)
        return fallback;

    switch (CONFIG_CLASS(type))
    {
    case CONFIG_ITEM_BOOL:
        return config_GetInt(name) != 0;
    case CONFIG_ITEM_INTEGER:
        return static_cast<qlonglong>(config_GetInt(name));
    case CONFIG_ITEM_FLOAT:
        return static_cast<double>(config_GetFloat(name));
    case CONFIG_ITEM_STRING:
    {
        char *val = config_GetPsz(name);
        if (!val)
            return fallback.isValid() ? fallback : QString();
        QString res = qfu(val);
        free(val);
        return res;
    }
    default:
        return fallback;
    }
}

bool ConfigModel::set(const QString &key, const QVariant &value)
{
    QByteArray ba = key.toUtf8();
    const char *name = ba.constData();
    int type = config_GetType(name);
    if (type == 0)
        return false;

    switch (CONFIG_CLASS(type))
    {
    case CONFIG_ITEM_BOOL:
        config_PutInt(name, value.toBool() ? 1 : 0);
        break;
    case CONFIG_ITEM_INTEGER:
        config_PutInt(name, value.toLongLong());
        break;
    case CONFIG_ITEM_FLOAT:
        config_PutFloat(name, value.toFloat());
        break;
    case CONFIG_ITEM_STRING:
    {
        QByteArray strVal = value.toString().toUtf8();
        config_PutPsz(name, strVal.constData());
        break;
    }
    default:
        return false;
    }

    emit configChanged(key, value);
    return true;
}

void ConfigModel::save()
{
    if (m_intf)
        config_SaveConfigFile(m_intf);
}

void ConfigModel::reset()
{
    config_ResetAll();
}

QVariantList ConfigModel::getChoices(const QString &key) const
{
    QVariantList list;
    QByteArray ba = key.toUtf8();
    const char *name = ba.constData();
    int type = config_GetType(name);
    if (type == 0)
        return list;

    if (CONFIG_CLASS(type) == CONFIG_ITEM_STRING)
    {
        char **values = nullptr;
        char **texts = nullptr;
        ssize_t count = config_GetPszChoices(name, &values, &texts);
        if (count > 0 && values)
        {
            for (ssize_t i = 0; i < count; ++i)
            {
                QVariantMap item;
                item["value"] = values[i] ? qfu(values[i]) : QString();
                item["text"] = (texts && texts[i]) ? qfu(texts[i]) : (values[i] ? qfu(values[i]) : QString());
                list.append(item);
                free(values[i]);
                if (texts && texts[i])
                    free(texts[i]);
            }
            free(values);
            if (texts)
                free(texts);
        }
    }
    else if (CONFIG_CLASS(type) == CONFIG_ITEM_INTEGER)
    {
        int64_t *values = nullptr;
        char **texts = nullptr;
        ssize_t count = config_GetIntChoices(name, &values, &texts);
        if (count > 0 && values)
        {
            for (ssize_t i = 0; i < count; ++i)
            {
                QVariantMap item;
                item["value"] = static_cast<qlonglong>(values[i]);
                item["text"] = (texts && texts[i]) ? qfu(texts[i]) : QString::number(values[i]);
                list.append(item);
                if (texts && texts[i])
                    free(texts[i]);
            }
            free(values);
            if (texts)
                free(texts);
        }
    }

    return list;
}

QString ConfigModel::getType(const QString &key) const
{
    QByteArray ba = key.toUtf8();
    const char *name = ba.constData();
    int type = config_GetType(name);
    if (type == 0)
        return QStringLiteral("unknown");

    switch (CONFIG_CLASS(type))
    {
    case CONFIG_ITEM_BOOL:
        return QStringLiteral("bool");
    case CONFIG_ITEM_INTEGER:
        return QStringLiteral("int");
    case CONFIG_ITEM_FLOAT:
        return QStringLiteral("float");
    case CONFIG_ITEM_STRING:
        return QStringLiteral("string");
    default:
        return QStringLiteral("unknown");
    }
}

QVariantList ConfigModel::searchConfig(const QString &query) const
{
    QVariantList results;
    size_t count = 0;
    module_t **list = module_list_get(&count);
    if (!list)
        return results;

    QString lowerQuery = query.trimmed().toLower();

    for (size_t i = 0; i < count; ++i)
    {
        module_t *mod = list[i];
        unsigned confsize = 0;
        module_config_t *const config = module_config_get(mod, &confsize);
        if (!config || confsize == 0)
        {
            module_config_free(config);
            continue;
        }

        QString modName = module_get_object(mod);

        for (size_t j = 0; j < confsize; ++j)
        {
            module_config_t *item = config + j;
            if (!item->psz_name)
                continue;

            QString name = qfu(item->psz_name);
            QString text = item->psz_text ? qfu(item->psz_text) : QString();
            QString longtext = item->psz_longtext ? qfu(item->psz_longtext) : QString();

            if (!lowerQuery.isEmpty() &&
                !name.toLower().contains(lowerQuery) &&
                !text.toLower().contains(lowerQuery) &&
                !longtext.toLower().contains(lowerQuery))
            {
                continue;
            }

            QVariantMap map;
            map["name"] = name;
            map["text"] = text.isEmpty() ? name : text;
            map["longtext"] = longtext;
            map["module"] = modName;
            map["type"] = getType(name);
            map["value"] = get(name);
            results.append(map);

            if (results.size() >= 200)
                break;
        }

        module_config_free(config);
        if (results.size() >= 200)
            break;
    }

    module_list_free(list);
    return results;
}
