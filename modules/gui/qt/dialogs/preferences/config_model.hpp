/*****************************************************************************
 * config_model.hpp : QML configuration model and backend bridge
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

#ifndef CONFIG_MODEL_HPP
#define CONFIG_MODEL_HPP

#include <QObject>
#include <QVariant>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

#include "qt.hpp"

class ConfigModel : public QObject
{
    Q_OBJECT

public:
    explicit ConfigModel(qt_intf_t *p_intf, QObject *parent = nullptr);
    ~ConfigModel() override = default;

    Q_INVOKABLE QVariant get(const QString &key, const QVariant &fallback = QVariant()) const;
    Q_INVOKABLE bool set(const QString &key, const QVariant &value);
    Q_INVOKABLE void save();
    Q_INVOKABLE void reset();
    Q_INVOKABLE QVariantList getChoices(const QString &key) const;
    Q_INVOKABLE QString getType(const QString &key) const;
    Q_INVOKABLE QVariantList searchConfig(const QString &query) const;

signals:
    void configChanged(const QString &key, const QVariant &value);

private:
    qt_intf_t *m_intf;
};

#endif // CONFIG_MODEL_HPP
