-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Noticeid_By_Emp]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[Noticeid_By_Emp](
	[NU] [int] IDENTITY(1,1) NOT NULL,
	[Notice_Ic] [int] NULL,
	[User_Id] [int] NULL,
 CONSTRAINT [PK_Noticeid_By_Emp] PRIMARY KEY CLUSTERED 
(
	[NU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

