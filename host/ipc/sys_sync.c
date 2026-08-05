/* host/sys_sync.c */
#if defined(__x86_64__) || defined(_M_X64)
#include <immintrin.h>
#endif

// 1. Platform-specific system headers
#if defined(_WIN32) || defined(_WIN64)
    #define WIN32_LEAN_AND_MEAN
    #include <windows.h>
#else
    #include <sched.h>
    #include <unistd.h>
#endif

// 2. Cross-platform threading
#include <pthread.h>

// 3. Atomics (Adding this just in case, since you are using atomic_* functions below)
#include <stdatomic.h>

#undef LOAD
#undef STORE

/* ── Atomic Convenience Macros */
#define L_R(v, ...)   atomic_load_explicit(&(v), memory_order_relaxed)
#define L(v)          atomic_load_explicit(&(v), memory_order_acquire)
#define S_R(v, x)     atomic_store_explicit(&(v), (x), memory_order_relaxed)
#define S(v, x)       atomic_store_explicit(&(v), (x), memory_order_release)
#define E_R(v, x)     atomic_exchange_explicit(&(v), (x), memory_order_relaxed)
#define E_A(v, x)     atomic_exchange_explicit(&(v), (x), memory_order_acquire)
#define FO(v, x)      atomic_fetch_or_explicit(&(v), (x), memory_order_release)
#define FA(v, x)      atomic_fetch_and_explicit(&(v), (x), memory_order_release)
#define CWX(v, e, d)  atomic_compare_exchange_weak_explicit(&(v), &(e), (d), \
                          memory_order_release, memory_order_relaxed)
#define CXS(v, e, d)  atomic_compare_exchange_strong_explicit(&(v), &(e), (d), \
                          memory_order_acquire, memory_order_relaxed)
#define TAS(v)        atomic_flag_test_and_set_explicit(&(v), memory_order_acquire)
#define CLR(v)        atomic_flag_clear_explicit(&(v), memory_order_release)

#if defined(_WIN32) || defined(_WIN64)
    #define SLEEP_MS(ms) Sleep(ms)
    #define EXPORT __declspec(dllexport)
#else
    #define SLEEP_MS(ms) usleep((ms) * 1000)
    #define EXPORT __attribute__((visibility("default")))
#endif

/* ── Threading Types & Macros (RESTORED) ── */
typedef pthread_t vmath_thread_t;
#define THREAD_FUNC        void*
#define THREAD_RETURN_VAL  NULL

/* ── Tiered Backoff Spinlock Wait */
static inline void vx_spin_wait(int* spin_count) {
    if (*spin_count < 1000) {
        _mm_pause(); // Tier 1: Nanoseconds
    } else if (*spin_count < 2000) {
        #if defined(_WIN32)
            SwitchToThread();
        #else
            sched_yield(); // Tier 2: Microseconds
        #endif
    } else {
        SLEEP_MS(1); // Tier 3: Milliseconds
    }
    (*spin_count)++;
}
