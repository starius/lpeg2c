#include "lpeg_all.h"

// function from lpeg (lpcode.c)
int lpeg_sizei(const Instruction *i) {
    switch ((Opcode)i->i.code) {
        case ISet: case ISpan:
            return CHARSETINSTSIZE;
        case ITestSet:
            return CHARSETINSTSIZE + 1;
        case ITestChar: case ITestAny:
        case IChoice: case IJmp:
        case ICall: case IOpenCall:
        case ICommit: case IPartialCommit:
        case IBackCommit:
            return 2;
        default:
            return 1;
    }
}

const char* lpeg_instName(const Instruction* inst) {
    const char* const NAMES[] = {
        "any", "char", "set",
        "testany", "testchar", "testset",
        "span", "behind",
        "ret", "end",
        "choice", "jmp", "call", "open_call",
        "commit", "partial_commit", "back_commit",
            "failtwice", "fail", "giveup",
        "fullcapture", "opencapture",
            "closecapture", "closeruntime"
    };
    const int NAMES_SIZE = sizeof(NAMES) / sizeof(const char*);
    int code = inst->i.code;
    if (code < NAMES_SIZE) {
        return NAMES[code];
    } else {
        return 0;
    }
}

int lpeg_hasChar(const Instruction* inst) {
    int code = inst->i.code;
    return code == IChar || code == ITestChar;
}

char lpeg_instChar(const Instruction* inst) {
    return inst->i.aux;
}

int lpeg_hasCharset(const Instruction* inst) {
    int code = inst->i.code;
    return code == ISet || code == ITestSet || code == ISpan;
}

const char* lpeg_instCharset(const Instruction* inst) {
    int code = inst->i.code;
    if (code == ISet || code == ISpan) {
        return (inst+1)->buff;
    } else {
        return (inst+2)->buff;
    }
}

int lpeg_hasRef(const Instruction* inst) {
    int code = inst->i.code;
    return code == ITestChar ||
        code == ITestSet ||
        code == IJmp ||
        code == ICall ||
        code == ICommit ||
        code == IChoice ||
        code == IPartialCommit ||
        code == IBackCommit ||
        code == ITestAny;
}

int lpeg_instRef(const Instruction* inst) {
    return (inst + 1)->offset;
}

int lpeg_hasKey(const Instruction* inst) {
    int code = inst->i.code;
    return code == IFullCapture || code == IOpenCapture;
}

int lpeg_instKey(const Instruction* inst) {
    return inst->i.key;
}
