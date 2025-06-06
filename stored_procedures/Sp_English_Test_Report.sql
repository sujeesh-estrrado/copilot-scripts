IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_English_Test_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_English_Test_Report]
@ProgramType bigint=0,
@Program  bigint=0,
@Intake varchar(max)='''',
@SearchKeyWord varchar(max)=''''
AS
BEGIN
select concat (MM.Candidate_Fname,'' '',MM.Candidate_Lname)as CandiadteName,MM.Candidate_Id as ID,
 CONVERT(varchar,AA.Create_date, 105) as CreateDate,MM.AdharNumber,DD.Department_Name,LL.Batch_Code,SS.Candidate_Email,SS.Candidate_Mob1
from Tbl_Secondery_Course_Inquery AA
--inner join Tbl_Seconday_Course BB on BB.id=AA.Course_id
left join Tbl_Candidate_Personal_Det MM on MM.Candidate_Id=AA.Candidate_id
left join tbl_New_Admission RR on RR.New_Admission_Id=MM.New_Admission_Id
left join Tbl_Department DD on DD.Department_Id=RR.Department_Id
left join Tbl_Course_Batch_Duration LL on LL.Batch_Id=RR.Batch_Id
left join Tbl_IntakeMaster IM on IM.id=LL.IntakeMasterID
left join Tbl_Candidate_ContactDetails SS on  SS.Candidate_Id=MM.Candidate_Id
where MM.Candidate_DelStatus=0 and (@ProgramType=0 or RR.Course_Category_Id=@ProgramType) 
and (@Program=0 or RR.Department_Id=@Program)
AND (IM.id IN (SELECT CAST(Item AS bigint) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')
 
and (concat (MM.Candidate_Fname,'''',MM.Candidate_Lname) like ''%'' +@SearchKeyWord+ ''%''or AA.Create_date like ''%'' +@SearchKeyWord+ ''%'' or
 
     MM.AdharNumber like ''%'' +@SearchKeyWord+ ''%'' or DD.Department_Name like ''%'' +@SearchKeyWord+ ''%''  
     or LL.Batch_Code like ''%'' +@SearchKeyWord+ ''%'' or SS.Candidate_Email like ''%'' +@SearchKeyWord+ ''%'' or SS.Candidate_Mob1 like ''%'' +@SearchKeyWord+ ''%'')

END
    ')
END
