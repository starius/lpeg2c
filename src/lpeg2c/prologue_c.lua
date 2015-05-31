return [[
#include <lua.h>
#include <lauxlib.h>
#include <limits.h>
#include <assert.h>

#define LPEG2C_FAIL (const char*)1

#define testchar(st,c) \
    (((int)(st)[((c) >> 3)] & (1 << ((c) & 7))))

typedef unsigned char byte;

#define caplistidx(ptop) ((ptop) + 2)
#define ktableidx(ptop) ((ptop) + 3)
#define stackidx(ptop) ((ptop) + 4)
#define BITSPERCHAR 8
#define CHARSETSIZE ((UCHAR_MAX/BITSPERCHAR) + 1)
#define FIXEDARGS 3

#define INITCAPSIZE 32
#define SUBJIDX 2

/* kinds of captures */
typedef enum CapKind {
  Cclose, Cposition, Cconst, Cbackref, Carg, Csimple, Ctable, Cfunction,
  Cquery, Cstring, Cnum, Csubst, Cfold, Cruntime, Cgroup
} CapKind;


typedef struct Capture {
  const char *s;  /* subject position */
  short idx;  /* extra info about capture (group name, arg index, etc.) */
  byte kind;  /* kind of capture */
  byte siz;  /* size of full capture + 1 (0 = not a full capture) */
} Capture;

typedef struct CapState {
  Capture *cap;  /* current capture */
  Capture *ocap;  /* (original) capture list */
  lua_State *L;
  int ptop;  /* index of last argument to 'match' */
  const char *s;  /* original string */
  int valuecached;  /* value stored in cache slot */
} CapState;

typedef struct MatchState {
    const char* o;
    const char* s;
    const char* e;
    lua_State* L;
    Capture* capture;
    int ptop;
    int captop;
} MatchState;

]]
