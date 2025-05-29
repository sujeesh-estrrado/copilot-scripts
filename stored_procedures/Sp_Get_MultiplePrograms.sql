IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_MultiplePrograms]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[Sp_Get_MultiplePrograms] 
	@id bigint
AS
BEGIN
	SELECT  l.Department_Name as option2,Ls.Department_Name as option3 FROM Tbl_Candidate_Personal_Det as H 
Left join tbl_New_Admission M on H.Option2=M.New_Admission_Id
Left join Tbl_Department L on M.Department_Id=L.Department_Id 
Left join tbl_New_Admission ME on H.Option3=ME.New_Admission_Id
Left join Tbl_Department LS on ME.Department_Id=LS.Department_Id where Candidate_Id=@id
END
    ')
END
