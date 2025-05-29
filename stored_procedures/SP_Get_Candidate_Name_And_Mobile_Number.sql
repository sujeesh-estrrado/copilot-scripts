IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Name_And_Mobile_Number]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Candidate_Name_And_Mobile_Number]   
 @Duration_Mapping_Id bigint  
AS  
BEGIN 
SELECT  ss.Candidate_Id , c.Candidate_Fname+'' ''+c.Candidate_Mname+'' ''+c.Candidate_Lname as CandidateName ,cc.Candidate_Mob1
FROM  Tbl_Student_Semester ss 
inner join Tbl_Candidate_Personal_Det c on c.Candidate_Id = ss.Candidate_Id
inner join Tbl_Candidate_ContactDetails cc on c.Candidate_Id=cc.Candidate_Id
 where Duration_Mapping_Id = @Duration_Mapping_Id
END    ');
END;