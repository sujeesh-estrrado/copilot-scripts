IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Details_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Get_Candidate_Details_By_ID]-- 36

(@Candidate_Id bigint)    
as    
begin    
select   
pd.Candidate_Id as ID,  
pd.Candidate_Fname + '' '' +      
pd.Candidate_Mname + '' '' +        
pd.Candidate_Lname as [Name],      
pd.Candidate_Gender as [Gender],      
pd.Candidate_Dob as [DOB],      
pd.Candidate_PlaceOfBirth as [PlaceOfBirth],      
pd.Candidate_Nationality as[Nationality],      
pd.Candidate_State as [State],  
pd.Religion as [Religion],  
pd.Caste as [Caste],   
pd.Diocese as [Diocese],    
pd.Parish as [Parish],    
pd.Candidate_FamilyIncome as [FamilyIncome],    
pd.Candidate_Img as [Image],   
  
cd.Candidate_PermAddress as [Presentadress],      
cd.Candidate_ContAddress as [Permanentadress],  
cd.Candidate_Telephone as [Telephone],  
cd.Candidate_Mob1 as [Mobile1],  
cd.Candidate_Mob2 as [Mobile2],   
cd.Candidate_Email as Email,     
cd.Candidate_FatherName as [Fathername],   
cd.Candidate_FatherOcc as [FatherOccupation],   
cd.Candidate_FatherQualification as [FatherQualification],   
cd.Candidate_MotherName as [Mothername],          
cd.Candidate_MotherOcc as [MotherOccupation],    
cd.Candidate_MotherQualification as [MotherQualification],        
cd.Candidate_GuardianName as [Gname],    
cd.Candidate_Relationship as [GRelationship],   
cd.Candidate_Guardian_Address as [Gadress],   
cd.Candidate_Guardian_Telephone as [Gtelephone],    
cd.Candidate_Guardian_Mob as [GMobile],   
cd.Candidate_Guardian_Email as [GEmail]     
     
--cad.[Candidate_Brother_Sister_OfThe _Applicant_Studyng_InThis_School] as [BrotherSisterStatus],  
--cad.Candidate_Brother_Sister_Name as [BrotherSisterStatus],  
--cad.Standard as [Standard],  
--cad.Division as [Division],  
--cad.Candidate_Name_OfThe_School_Last_Attended as [PreviousSchool],  
--cad.Candidate_Place_OfThe_School_Last_Attended as [PreviousSchoolPlace],  
--cad.Candidate_Boarder as [BoaderStatus],  
--cad.Candidate_Dayscholar as [DayscholarStatus],  
--cad.Candidate_School_Bus_Number as [SchoolBusNumber],  
--cad.Candidate_Boarding_Point as [BoardingPoint],  
--cad.Candidate_Identification_Marks as [IdentificationMarks],  
--cad.Candidate_Mother_Tounge as [Mother_Tounge]  
  
from  dbo.Tbl_Candidate_Personal_Det as pd
 inner join dbo.Tbl_Candidate_ContactDetails as cd on pd.Candidate_Id=cd.Candidate_Id 
 --inner join dbo.Tbl_Candidate_Additional_Details as cad on cd.Candidate_Id=cad.Candidate_Id 
 where pd.Candidate_Id = @Candidate_Id

    
end
    ')
END;
