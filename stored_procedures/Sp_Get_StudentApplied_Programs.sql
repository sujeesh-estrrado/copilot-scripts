IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_StudentApplied_Programs]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_StudentApplied_Programs]-- 2,10104
    (
    @Flag int=0,
    @Candidate_Id bigint=0
    )
AS
BEGIN
if(@Flag=1)
    begin
        Select d.Department_Name as option2 from Tbl_Student_NewApplication cpd 
        left join tbl_New_Admission tm ON cpd.Option2=tm.New_Admission_Id 
        inner join Tbl_Department d on d.Department_Id=tm.Department_Id  
        where Candidate_Id=@Candidate_Id
    end
if (@Flag=2)
    begin
        Select f.Department_Name as option3 from Tbl_Student_NewApplication cpd 
        left join tbl_New_Admission tm ON cpd.Option3=tm.New_Admission_Id 
        inner join Tbl_Department f on f.Department_Id=tm.Department_Id  
        where Candidate_Id=@Candidate_Id
    end
END
    ')
END;