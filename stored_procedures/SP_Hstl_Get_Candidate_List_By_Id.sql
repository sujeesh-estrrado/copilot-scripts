IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Hstl_Get_Candidate_List_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Hstl_Get_Candidate_List_By_Id](@Candidate_Id bigint)  
AS    
BEGIN    
    
 SELECT HS.Student_Id ,  
 CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname as CandidateName,    
 CPD.Candidate_Dob as DOB,  
 CPD.New_Admission_Id as AdmnID,  
CPD.Candidate_Gender,  
CPD.Candidate_PlaceOfBirth,  
CPD.Candidate_Nationality,  
CPD.Candidate_State,  
CPD.Religion,  
CPD.Caste,  
CPD.Diocese,  
CPD.Parish,  
CPD.ApplicationCategory,  
CPD.Candidate_Category,  
CPD.Candidate_FamilyIncome,  
CPD.Candidate_Img,  
 CC.Candidate_ContAddress as Address,    
 CC.Candidate_Mob1 as MobileNumber,  
 CC.Candidate_Email as EmailID ,  
 NA.Batch_Id as BatchID,  
 CBD.Batch_Code as Batch,  
  
 NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],  
 NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],  
 NA.Department_Id as DepartmentID,D.Department_Name as [Department]  
   
  
  
   
FROM Tbl_Candidate_Personal_Det  CPD  
    
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id   
inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id  
inner join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id  
inner join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id  
inner join Tbl_Department D On D.Department_Id=NA.Department_Id  
inner join Tbl_Hstl_Student_Admission HS on HS.Student_Id=CPD.Candidate_Id
  
  
--INNER Join  Tbl_Candidate_CoursePriority CP On CP.Candidate_Id=CPD.Candidate_Id  
  
    
where CPD.Candidate_DelStatus=0 and CPD.Candidate_Id=@Candidate_Id  
    
END
    ');
END;
