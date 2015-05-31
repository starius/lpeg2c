#ifndef lpeg_all_h
#define lpeg_all_h

#define LPEG_DEBUG

#include "lpcap.h"
#include "lpcode.h"
#include "lpprint.h"
#include "lptree.h"
#include "lptypes.h"
#include "lpvm.h"

int lpeg_sizei(const Instruction *i);

const char* lpeg_instName(const Instruction* inst);

int lpeg_hasChar(const Instruction* inst);
char lpeg_instChar(const Instruction* inst);
int lpeg_hasCharset(const Instruction* inst);
const char* lpeg_instCharset(const Instruction* inst);
int lpeg_hasRef(const Instruction* inst);
int lpeg_instRef(const Instruction* inst);
int lpeg_hasKey(const Instruction* inst);
int lpeg_instKey(const Instruction* inst);

#endif
