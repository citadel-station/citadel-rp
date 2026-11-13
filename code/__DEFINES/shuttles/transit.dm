//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#warn below

//* transit callback status *//

/// at destination
///
/// * this is purely a 'we are at destination'. we do not need a successful docking
/// * as an example, if we land on a dock, but don't have codes, this is still successful!
/// * again, this is only the transit status, not the docking status!
#define SHUTTLE_TRANSIT_STATUS_SUCCESS 1
/// aborted; destination was blocked on arrival
#define SHUTTLE_TRANSIT_STATUS_BLOCKED 2
/// aborted ; we got cancelled
#define SHUTTLE_TRANSIT_STATUS_CANCELLED 3
/// aborted ; we're going somewhere else
#define SHUTTLE_TRANSIT_STATUS_REDIRECTED 4
/// aborted ; unknown abort
#define SHUTTLE_TRANSIT_STATUS_FAILED 5

//* transit flags *//

/// should not interrupt via normal means
///
/// * without FORCE_UNDOCK / DOCK / TAKEOFF / LANDING, the transit can still be aborted by a timeout.
#define SHUTTLE_TRANSIT_FLAG_NO_ABORT (1<<0)
/// do not allow users to abort mid-transit; does not prevent aborts while outside of transit jump
#define SHUTTLE_TRANSIT_FLAG_NO_TRANSIT_ABORT (1<<1)
/// do not obtain exclusive lock on dock
/// * sometimes necessary, makes accidental orphaning more likely.
#define SHUTTLE_TRANSIT_FLAG_NO_DOCK_MUTEX (1<<2)

DECLARE_BITFIELD(shuttle_transit_flags, list(
	BITFIELD_NAMED("Disallow Abort", SHUTTLE_TRANSIT_FLAG_NO_ABORT),
	BITFIELD_NAMED("Disallow Abort in Transit", SHUTTLE_TRANSIT_FLAG_NO_TRANSIT_ABORT),
	BITFIELD_NAMED("No Exclusive Lock on Target Dock", SHUTTLE_TRANSIT_FLAG_NO_DOCK_MUTEX),
))
ASSIGN_BITFIELD(shuttle_transit_flags, /datum/shuttle_transit_cycle, transit_flags)

//* traversal flags *//

/// immediate force of takeoff / landing
///
/// * doesn't wait, just slam through checks
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT (1<<0)
/// immediate force of docking / undocking
///
/// * doesn't wait, just slam through checks
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING (1<<1)
/// force if something fails, not just times out
///
/// * implies FORCE_ON_TIMEOUT
/// * does wait for all other checks to either fail or time out
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_FAIL (1<<2)
/// force if something fails, not just times out
///
/// * implies FORCE_ON_TIMEOUT
/// * does wait for all other checks to either fail or time out
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_FAIL (1<<3)
/// force if something times out, but not if it fails
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_TIMEOUT (1<<4)
/// force if something times out, but not if it fails
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_TIMEOUT (1<<5)
/// prevents negative effects from takeoff / landing
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_SAFETY (1<<6)
/// prevents negative effects from dock / undock step
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_SAFETY (1<<7)

#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_IMMEDIATE ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_SAFETY ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_SAFETY | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_SAFETY \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_FAIL | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_FAIL \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_TIMEOUT ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_TIMEOUT | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_TIMEOUT \
)

DECLARE_BITFIELD(shuttle_traversal_flags, list(
	BITFIELD_NAMED("Force Takeoff / Landing", SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT),
	BITFIELD_NAMED("Force Takeoff / Landing on fail", SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_FAIL),
	BITFIELD_NAMED("Force Takeoff / Landing on timeout", SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_ON_TIMEOUT),
	BITFIELD_NAMED("Force Takeoff / Landing safety", SHUTTLE_TRAVERSAL_FLAG_FORCE_TRANSIT_SAFETY),
	BITFIELD_NAMED("Force Docking / Undocking", SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING),
	BITFIELD_NAMED("Force Docking / Undocking on fail", SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_FAIL),
	BITFIELD_NAMED("Force Docking / Undocking on timeout", SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_TIMEOUT),
	BITFIELD_NAMED("Force Docking / Undocking safety", SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_SAFETY),
))
ASSIGN_BITFIELD(shuttle_traversal_flags, /datum/shuttle_transit_cycle, traversal_flags_source)
ASSIGN_BITFIELD(shuttle_traversal_flags, /datum/shuttle_transit_cycle, traversal_flags_target)
