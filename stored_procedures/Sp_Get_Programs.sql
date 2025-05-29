IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Programs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
    CREATE procedure [dbo].[Sp_Get_Programs]-- 2,10104
    (
    @Flag int=0,
    @Candidate_Id bigint=0


    )
AS
BEGIN
if
@Flag=1
begin
Select d.Department_Name as option2,d.Department_Id as option2_New_Admission_Id,cpd.Mode_Of_Study AS Study_Mode
,CC.Course_Category_Name AS LevelOfStudy,''-NA-'' AS Faculty,''NA''AS Organization_Name from Tbl_Candidate_Personal_Det cpd 
left join tbl_New_Admission tm ON cpd.Option2=tm.New_Admission_Id inner join Tbl_Department d on d.Department_Id=tm.Department_Id 
LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id=TM.Course_Category_Id
where Candidate_Id=@Candidate_Id
end
if 
@Flag=2
begin
Select f.Department_Name as option3,f.Department_Id as option3_New_Admission_Id,cpd.Mode_Of_Study AS Study_Mode,
''-NA-'' AS Faculty,''NA''AS Organization_Name,CC.Course_Category_Name AS LevelOfStudy  from Tbl_Candidate_Personal_Det cpd 
left join tbl_New_Admission tm ON cpd.Option3=tm.New_Admission_Id inner join Tbl_Department f on f.Department_Id=tm.Department_Id 
LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id=TM.Course_Category_Id
where Candidate_Id=@Candidate_Id
end
END


');
END;
