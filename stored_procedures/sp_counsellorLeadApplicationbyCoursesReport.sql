IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_counsellorLeadApplicationbyCoursesReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_counsellorLeadApplicationbyCoursesReport] --0,''1158,1194,815,1146'',1
(
@Department_ID bigint = 0,
@EmployeeIds varchar(max)='''',
@flag bigint=0
)
as

begin
Declare @CurrentYear bigint
Declare @OneYearback bigint
Declare @TwoYearback bigint


set @CurrentYear=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det CPD left join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id where Department_Id=@Department_ID and year(CPD.RegDate)=YEAR(GETDATE()) and (CPD.CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @OneYearback=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det CPD left join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id where Department_Id=@Department_ID and year(CPD.RegDate)=year(DATEADD(year,-1,GETDATE())) and (CPD.
CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))
set @TwoYearback=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det CPD left join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id where Department_Id=@Department_ID and year(CPD.RegDate)=year(DATEADD(year,-2,GETDATE())) and (CPD.
CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))
if(@flag=0)
    begin
        
     Create table #tempchart(CurrentYear varchar(Max),OneYearback varchar(Max),TwoYearback varchar(Max))
insert into #tempchart
select @CurrentYear as CurrentYear ,@OneYearback as OneYearback ,@TwoYearback as TwoYearback 

select * from #tempchart --where value!=0



end
 if(@flag=1)
    begin
        
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds='''')
        union all
        select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))t 
    end

end
    ')
END
