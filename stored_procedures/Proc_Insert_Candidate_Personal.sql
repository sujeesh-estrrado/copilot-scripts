IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Candidate_Personal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Candidate_Personal]
(
    @Candidate_FName varchar(100),
    @Candidate_MName varchar(100),
    @Candidate_LName varchar(100),
    @Candidate_Gender varchar(10),
    @Candidate_Dob Datetime,
    @Candidate_Address_Present varchar(MAX),
    @Candidate_Address_Permanent varchar(MAX),
    @Candidate_Phone Bigint,
    @Candidate_Mob Bigint,
    @Candidate_Category varchar(200),
    @Candidate_Religion varchar(100),
    @Candidate_Caste varchar(200),
    @Candidate_Image varchar(MAX),
    @Appln_Year int,
    @LastStudiedCourse int
)
As

Begin

    Insert into Tbl_Candidate_Personal(Candidate_FName,Candidate_MName,Candidate_LName,Candidate_Gender,
    Candidate_Dob,Candidate_Address_Present,Candidate_Address_Permanent,Candidate_Phone,Candidate_Mob,
    Candidate_Category,Candidate_Religion,Candidate_Caste,Candidate_Image,Appln_Year,LastStudiedCourse)
    values(@Candidate_FName,@Candidate_MName,@Candidate_LName,@Candidate_Gender,
    @Candidate_Dob,@Candidate_Address_Present,@Candidate_Address_Permanent,@Candidate_Phone,@Candidate_Mob,
    @Candidate_Category,@Candidate_Religion,@Candidate_Caste,@Candidate_Image,@Appln_Year,@LastStudiedCourse)
    
    Select SCOPE_IDENTITY()
End
   ')
END;
