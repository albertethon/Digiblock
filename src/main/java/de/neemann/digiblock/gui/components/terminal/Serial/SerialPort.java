package de.neemann.digiblock.gui.components.terminal.Serial;

import de.neemann.digiblock.core.Node;
import de.neemann.digiblock.core.NodeException;
import de.neemann.digiblock.core.ObservableValue;
import de.neemann.digiblock.core.ObservableValues;
import de.neemann.digiblock.core.element.Element;
import de.neemann.digiblock.core.element.ElementAttributes;
import de.neemann.digiblock.core.element.ElementTypeDescription;
import de.neemann.digiblock.core.element.Keys;
import de.neemann.digiblock.draw.elements.PinException;
import de.neemann.digiblock.gui.components.terminal.Terminal;
import de.neemann.digiblock.gui.components.terminal.TerminalDialog;

import javax.swing.*;
import java.awt.*;

import static de.neemann.digiblock.core.element.PinInfo.input;

public class SerialPort extends Node implements Element {

    /**
     * The serialport description
     */
    public static final ElementTypeDescription DESCRIPTION
            = new ElementTypeDescription(SerialPort.class,
            input("C").setClock(),
            input("en"))
            .addAttribute(Keys.ROTATE)
            .addAttribute(Keys.LABEL);

    private final String label;
    private final ElementAttributes attr;
    private SerialDialog serialDialog;
    private ObservableValue clock;
    private boolean lastClock;
    private ObservableValue en;
    private ObservableValue data;

    public SerialPort(ElementAttributes attributes) {
        attr = attributes;
        label = attributes.getLabel();
        data = new ObservableValue("D", 8)
                .setToHighZ()
                .setPinDescription(DESCRIPTION);
    }

    @Override
    public void readInputs() throws NodeException {
        boolean clockVal = clock.getBool();
        if (!lastClock && clockVal && en.getBool()) {
            java.awt.EventQueue.invokeLater(new Runnable() {
                public void run() {
                    new SerialDialog().setVisible(true);
                }
            });
        }
        lastClock = clockVal;
    }

    @Override
    public void writeOutputs() throws NodeException {

    }

    @Override
    public void setInputs(ObservableValues inputs) throws NodeException {
        clock = inputs.get(0).addObserverToValue(this).checkBits(1, this);
        en = inputs.get(1).addObserverToValue(this).checkBits(1, this);
    }

    @Override
    public ObservableValues getOutputs() throws PinException {
        return ObservableValues.EMPTY_LIST;
    }
}
