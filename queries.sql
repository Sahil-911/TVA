--push query
-- make a new version vn
-- set latest_version to vn
--compare with the latest local of timeline and add change to the change table set version id to vn
-- make a new local
-- set timeline(timeline#n)'s latest local to local#n
-- add all files & lines with "local#n,project#n" to the new local
--pull query
--remove all files with local#n
--copy all files & lines from the "latest local of timeline" to local#n
-- revert one version back
-- do all the changes to latest_local (line table)



-- update a line
UPDATE "Line"
SET "Content" = "abcde"
WHERE "Line_id" = "line#n"
     AND "File_id" = "file#n"
     AND "local_id" = "local#n"
     AND "Project_id" = "project#n";
-- delete a line
UPDATE "Line"
SET "Content" = ""
WHERE "Line_id" = "line#n"
     AND "File_id" = "file#n"
     AND "local_id" = "local#n"
     AND "Project_id" = "project#n";
-- clear a file
DELETE FROM "Line"
WHERE "File_id" = "file#n"
     AND "local_id" = "local#n"
     AND "Project_id" = "project#n";
UPDATE "File"
SET length = 0
WHERE "File_id" = "file#n"
     AND "local_id" = "local#n"
     AND "Project_id" = "project#n";