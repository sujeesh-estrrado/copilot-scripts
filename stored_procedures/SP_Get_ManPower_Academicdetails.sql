IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ManPower_Academicdetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create PROCEDURE [dbo].[SP_Get_ManPower_Academicdetails]  
@Manpower_Id bigint,  
@Programme_Id bigint  
AS  
BEGIN  
SELECT A.[ID] AS Academic_Id,A.Manpower_Id,A.[Programme_Id],A.[YearOfStudy],A.[Qulification_Required],A.[AreaOfSpecialization],A.[Minimum_YearOfTeaching_Experience]  
   ,A.[Minimum_YearOf_Industrial_Experience],A.[Knowledge_And_Skill],A.[Traits_Required]  
   ,D.[Department_Name]  
   FROM [dbo].[Tbl_ManPower_Academic] A  
    LEFT JOIN [dbo].[Tbl_Department] D ON D.Department_Id= A.[Programme_Id]  
   WHERE [Manpower_Id]=@Manpower_Id AND A.ID=@Programme_Id AND [Del_Status]=0  
END
    ')
END
