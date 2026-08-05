/* host/state_globals.c */

EngineState      g_engine;
RenderRing       g_ring;

RenderThreadInit g_window_wsi[MAX_WINDOWS]; // Provided by SSOT header
atomic_int       g_wsi_state[MAX_WINDOWS];
atomic_int       g_render_busy[MAX_WINDOWS];
atomic_int       g_transfer_busy[MAX_WINDOWS];

vmath_thread_t   g_render_thread;
atomic_int       g_render_thread_active;

TransferJob      g_transfer_ring[TRANSFER_RING_SIZE];

vmath_thread_t   g_transfer_thread;
atomic_int       g_transfer_thread_active;

VkCommandPool    g_render_cmd_pools[MAX_WINDOWS];
VkCommandPool    g_transfer_cmd_pools[MAX_WINDOWS];
VkCommandBuffer  g_render_cmd_buffers[MAX_WINDOWS][3];
VkCommandBuffer  g_transfer_cmd_buffers[MAX_WINDOWS];
VkFence          g_transfer_fences[MAX_WINDOWS];
