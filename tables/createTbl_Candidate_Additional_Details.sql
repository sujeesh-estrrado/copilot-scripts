-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_Additional_Details]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_Additional_Details] (
    [Candidate_Additional_Details_Id]                                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [Candidate_Id]                                                    BIGINT        NOT NULL,
    [Candidate_Brother_Sister_OfThe _Applicant_Studyng_InThis_School] BIT           NOT NULL,
    [Candidate_Brother_Sister_Name]                                   VARCHAR (100) NULL,
    [Standard]                                                        VARCHAR (50)  NULL,
    [Division]                                                        VARCHAR (50)  NULL,
    [Candidate_Name_OfThe_School_Last_Attended]                       VARCHAR (100) NOT NULL,
    [Candidate_Place_OfThe_School_Last_Attended]                      VARCHAR (100) NOT NULL,
    [Candidate_Boarder]                                               BIT           NULL,
    [Candidate_Dayscholar]                                            BIT           NULL,
    [Candidate_School_Bus_Number]                                     VARCHAR (100) NULL,
    [Candidate_Boarding_Point]                                        VARCHAR (100) NULL,
    [Candidate_Identification_Marks]                                  VARCHAR (200) NOT NULL,
    [Candidate_Mother_Tounge]                                         VARCHAR (50)  NULL
)




END

