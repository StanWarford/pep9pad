#include "byteconverterinstr.h"
#include "ui_byteconverterinstr.h"

#include "pep.h"
#include "sim.h"

ByteConverterInstr::ByteConverterInstr(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ByteConverterInstr)
{
    ui->setupUi(this);


}

ByteConverterInstr::~ByteConverterInstr()
{
    delete ui;
}

void ByteConverterInstr::setValue(int data)
{
    ui->label->setText(" " + Pep::enumToMnemonMap.value(Pep::decodeMnemonic[data])
                       + Pep::addrModeToCommaSpace(Pep::decodeAddrMode[data]));
    // NOTE: in Pep9Pad, addrModeToCommaSpace is `Pep.commaSpaceStringForAddrMode()`
}

void ByteConverterInstr::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}
