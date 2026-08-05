/* host/thread_pool.c */

vmath_thread_t vmath_thread_start(void* (*func)(void*), void* arg) {
    pthread_t thread;
    pthread_create(&thread, NULL, func, arg);
    return thread;
}

void vmath_thread_join(vmath_thread_t thread) {
    pthread_join(thread, NULL);
}
