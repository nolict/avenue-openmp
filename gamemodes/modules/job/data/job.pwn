/*
    File: modules/job/data/job.pwn
    Purpose: Defines job data structures, constants, static arrays, or runtime storage for job.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Job Data ======
enum jobData {
	jobID,
	jobExists,
	jobType,
	Float:jobPos[3],
	Float:jobPoint[3],
	Float:jobDeliver[3],
	jobInterior,
	jobWorld,
	jobPointInt,
	jobPointWorld,
	jobPickups[3],
	Text3D:jobText3D[3]
};

new JobData[MAX_DYNAMIC_JOBS][jobData];
