import threading

fShutdown = False

# Upstream Stratum state
upstream_sock = None
upstream_send_lock = threading.Lock()
upstream_extranonce1 = None
upstream_extranonce2_size = 4
upstream_difficulty = None
sub_details = None
connected = False
upstream_alive = False

# Current upstream mining job
job_id = None
mining_job_id = None
prevhash = None
coinb1 = None
coinb2 = None
merkle_branch = None
version = None
nbits = None
ntime = None
clean_jobs = False
updatedPrevHash = None
job_generation = 0

# Upstream mining.submit routing.
# upstream request id -> submit timestamp
pending_submits = {}
pending_submits_lock = threading.Lock()
next_submit_id = 1000000

# Statistics
shares_submitted = 0
shares_accepted = 0
shares_rejected = 0
total_hashes = 0

# Compatibility fields kept for older code/users of the module.
extranonce1 = None
extranonce2_size = None
extranonce2 = None
sock = None
sock_lock = threading.Lock()
job_lock = threading.Lock()
local_height = 0
current_height = 0
nHeightDiff = {}
