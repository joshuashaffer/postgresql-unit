-- version 1
SET client_min_messages = warning;
DROP EXTENSION IF EXISTS unit CASCADE;
RESET client_min_messages;
CREATE EXTENSION IF NOT EXISTS unit VERSION "1";

CREATE TABLE IF NOT EXISTS pg_depend_save (LIKE pg_depend);
BEGIN;
	DELETE FROM pg_depend_save;
	WITH
		ext AS (DELETE FROM pg_depend WHERE refobjid =
			(SELECT oid FROM pg_extension WHERE extname = 'unit')
			RETURNING *)
	INSERT INTO pg_depend_save SELECT * FROM ext;
COMMIT;
\! pg_dump -f unit-1.dump -T pg_depend_save
INSERT INTO pg_depend SELECT * FROM pg_depend_save;

-- upgrade to version 2
ALTER EXTENSION unit UPDATE TO "2";

BEGIN;
	DELETE FROM pg_depend_save;
	WITH
		ext AS (DELETE FROM pg_depend WHERE refobjid =
			(SELECT oid FROM pg_extension WHERE extname = 'unit')
			RETURNING *)
	INSERT INTO pg_depend_save SELECT * FROM ext;
COMMIT;
\! pg_dump -f unit-1-2.dump -T pg_depend_save
INSERT INTO pg_depend SELECT * FROM pg_depend_save;

-- upgrade to version 3
ALTER EXTENSION unit UPDATE TO "3";

BEGIN;
	DELETE FROM pg_depend_save;
	WITH
		ext AS (DELETE FROM pg_depend WHERE refobjid =
			(SELECT oid FROM pg_extension WHERE extname = 'unit')
			RETURNING *)
	INSERT INTO pg_depend_save SELECT * FROM ext;
COMMIT;
\! pg_dump -f unit-2-3.dump -T pg_depend_save
INSERT INTO pg_depend SELECT * FROM pg_depend_save;

-- upgrade to version 4
ALTER EXTENSION unit UPDATE TO "4";

BEGIN;
	DELETE FROM pg_depend_save;
	WITH
		ext AS (DELETE FROM pg_depend WHERE refobjid =
			(SELECT oid FROM pg_extension WHERE extname = 'unit')
			RETURNING *)
	INSERT INTO pg_depend_save SELECT * FROM ext;
COMMIT;
\! pg_dump -f unit-3-4.dump -T pg_depend_save
INSERT INTO pg_depend SELECT * FROM pg_depend_save;

-- reinstall latest version
DROP EXTENSION unit CASCADE;
CREATE EXTENSION unit;

BEGIN;
	DELETE FROM pg_depend_save;
	WITH
		ext AS (DELETE FROM pg_depend WHERE refobjid =
			(SELECT oid FROM pg_extension WHERE extname = 'unit')
			RETURNING *)
	INSERT INTO pg_depend_save SELECT * FROM ext;
COMMIT;
\! pg_dump -f unit-4.dump -T pg_depend_save
INSERT INTO pg_depend SELECT * FROM pg_depend_save;
