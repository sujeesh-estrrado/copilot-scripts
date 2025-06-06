IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Accommodation_Report]') 
    AND type = N'P'
)
BEGIN
    DECLARE @SQL NVARCHAR(MAX) = N'
    
    CREATE pROCEDURE [dbo].[Sp_Accommodation_Report]-- 1,45,''''
(
@ProgramType bigint=0,
@Program  bigint=0,
@Intake varchar(max)=''''
)
    
AS
BEGIN
select concat (CPD.Candidate_Fname,'''',CPD.Candidate_Lname)as CandiadteName,CPD.Candidate_Id as ID,
CPD.AdharNumber,DD.Department_Name,LL.Batch_Code,SS.Candidate_Email,SS.Candidate_Mob1,CN.Country,CPD.Room_Type
from Tbl_Candidate_Personal_Det CPD 
left join tbl_New_Admission RR on RR.New_Admission_Id=CPD.New_Admission_Id
left join Tbl_Department DD on DD.Department_Id=RR.Department_Id
left join Tbl_Course_Batch_Duration LL on LL.Batch_Id=RR.Batch_Id
left join Tbl_Candidate_ContactDetails SS on  SS.Candidate_Id=CPD.Candidate_Id
left join Tbl_Candidate_ContactDetails PCD on PCD.Candidate_id=CPD.Candidate_Id
left join Tbl_Country CN on CN.Country_id=PCD.Candidate_PermAddress_Country
left join Tbl_IntakeMaster IM on IM.id=LL.IntakeMasterID
where CPD.Candidate_DelStatus=0 and CPD.Hostel_Required=1
and (@ProgramType=0 or RR.Course_Category_Id=@ProgramType) 
and (@Program=0 or RR.Department_Id=@Program)
and( RR.Batch_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''') 

END
';

    EXEC sp_executesql @SQL;
END;
