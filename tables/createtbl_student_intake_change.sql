-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_student_intake_change]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_student_intake_change](
	[candidate_id] [bigint] NULL,
	[old_new_admission_id] [bigint] NULL,
	[New_new_admission_id] [bigint] NULL,
	[create_date] [datetime] NULL

) ON [PRIMARY]
END

