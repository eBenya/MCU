
//#include "protocol_lib.c"

// ==========================================================================
// ���������� ����������� ����� ����� ������. (len < 256 !!!)

unsigned char Crc8(unsigned char *pcBlock, unsigned char len);

// ==========================================================================
// ���������� ����������� ����� ����� ������. (len < 256 !!!)

unsigned int CRC16(unsigned char * pcBlock, unsigned char len);
// ==========================================================================
// ������� ��� ���������� ������� ����������� �����. (�� ������ ���. 0xFFFF)

void CRC16_Byte(unsigned char byte, unsigned int *crc);

//