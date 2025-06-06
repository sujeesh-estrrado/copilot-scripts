-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Health_General]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Health_General](
	[GenearlId] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NOT NULL,
	[BloodGroup] [varchar](30) NULL,
	[GeneralAppearance] [varchar](30) NULL,
	[Weight] [varchar](50) NULL,
	[Height] [varchar](50) NULL,
	[EyeVision] [varchar](50) NULL,
	[LE] [varchar](50) NULL,
	[Squint] [varchar](50) NULL,
	[Conjuctivita] [varchar](50) NULL,
	[Cornea] [varchar](50) NULL,
	[Ears] [varchar](50) NULL,
	[ExternalEars] [varchar](50) NULL,
	[MiddleEar] [varchar](50) NULL,
	[OralCavity] [varchar](50) NULL,
	[Gums] [varchar](50) NULL,
	[Colour] [varchar](50) NULL,
	[TeethOcclusion] [varchar](50) NULL,
	[Caries] [varchar](50) NULL,
	[Tonsils] [varchar](50) NULL,
	[LymphNodes] [varchar](50) NULL,
	[Pulse] [varchar](50) NULL,
	[Bp] [varchar](50) NULL,
	[Nails] [varchar](50) NULL,
	[Skin] [varchar](50) NULL,
	[Muscle] [varchar](50) NULL,
	[Feet] [varchar](50) NULL,
 CONSTRAINT [PK_Tbl_Student_Health_General_1] PRIMARY KEY CLUSTERED 
(
	[GenearlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

