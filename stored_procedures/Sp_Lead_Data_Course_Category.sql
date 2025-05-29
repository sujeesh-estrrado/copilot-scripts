IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Lead_Data_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Lead_Data_Course_Category]
@Flag int=0
AS
BEGIN
--select COUNT(CC.Course_Category_Id) AS COUNT,CC.Course_Category_Name from Tbl_Course_Category CC
--join tbl_New_Admission NW on NW.Course_Category_Id=CC.Course_Category_Id GROUP BY Course_Category_Name

DECLARE @Month int
DECLARE @Year int
declare @from datetime;
declare @to datetime;
set @Month = month(getdate());
set @Year = year(getdate());

set @from = DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0)) /*First*/

set @to= DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))

select COUNT(cpd.Candidate_Id) AS COUNT,isnull(CC.Course_Category_Name,''Others'') Course_Category_Name from Tbl_Candidate_Personal_Det cpd 
left join tbl_New_Admission na on na.new_admission_id= cpd.new_admission_id
left join Tbl_Course_Batch_Duration cbd on cbd.batch_id = na.batch_id
left join tbl_department d on d.department_id = cbd.duration_id
left join Tbl_Course_Category cc on cc.Course_Category_Id = d.Program_Type_Id
where   cpd.RegDate >=  @from and @to >=cpd.RegDate 

GROUP BY Course_Category_Name order by Course_Category_Name




end
');
END;