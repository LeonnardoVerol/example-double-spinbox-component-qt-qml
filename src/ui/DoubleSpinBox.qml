import QtQuick
import QtQuick.Controls

Item {
    id: control

    property int decimals: 2
    property real value: 0.0
    property real from: 0.0
    property real to: 100.0
    property real stepSize: 1.0
    property bool editable: false

    signal valueModified()

    function localeValue(value, locale = Qt.locale())
    {
        return Number(value).toLocaleString(locale, 'f', control.decimals);
    }

    SpinBox {
        id: spinbox

        property real factor: Math.pow(10, control.decimals)

        function doubleValue()
        {
            return parseFloat(spinbox.value * 1.0 / spinbox.factor);
        }

        stepSize: control.stepSize * spinbox.factor
        value: control.value * spinbox.factor
        to : control.to * spinbox.factor
        from : control.from * spinbox.factor

        validator: DoubleValidator {
            bottom: Math.min(spinbox.from, spinbox.to) * spinbox.factor
            top:  Math.max(spinbox.from, spinbox.to) * spinbox.factor
        }

        textFromValue: (value, locale) => { return control.localeValue(spinbox.doubleValue(), locale); }
        valueFromText: (text, locale) => { return Number.fromLocaleString(locale, text) * spinbox.factor; }

        onValueModified: {
            control.value = spinbox.doubleValue();
            control.valueModified();
        }
    }
}
