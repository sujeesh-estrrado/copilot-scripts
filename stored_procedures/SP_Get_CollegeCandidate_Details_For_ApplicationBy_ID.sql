IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CollegeCandidate_Details_For_ApplicationBy_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CollegeCandidate_Details_For_ApplicationBy_ID] (@Candidate_Id bigint)                
as                
begin                
select               
              
              
pd.Candidate_Id as ID,              
              
SR.Student_Serial_No,              
SR.Student_Reg_No,              
              
pd.Candidate_Fname + '' '' +                  
pd.Candidate_Mname + '' '' +                    
pd.Candidate_Lname as [CandidateName],                  
pd.Candidate_Gender as [Gender],                  
pd.Candidate_Dob as [DOB],           
--DATEDIFF(hour,pd.Candidate_Dob,GETDATE())/8766.0 AS AgeYearsDecimal,          
--CONVERT(int,ROUND(DATEDIFF(hour,pd.Candidate_Dob,GETDATE())/8766.0,0)) AS [Round age year],           
--DATEDIFF(hour,pd.Candidate_Dob,GETDATE())/8766 AS [Truncated age year],               
cc.Course_Category_Name +'' '' + d.Department_Name as [Class],              
pd.Candidate_PlaceOfBirth as [PlaceOfBirth],                  
pd.Candidate_Nationality as[Nationality],                  
pd.Candidate_State as [State],              
pd.Religion +'' ''+              
pd.Caste as [ReligionandCaste],               
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
          
[FatherQualification]=case when cd.Candidate_FatherQualification        
is null then '' '' else   cd.Candidate_FatherQualification end,        
            
cd.Candidate_MotherName as [Mothername],                      
cd.Candidate_MotherOcc as [MotherOccupation],           
        
[MotherQualification]=case when cd.Candidate_MotherQualification        
is null then '' '' else   cd.Candidate_MotherQualification end,             
                
cd.Candidate_GuardianName as [Gname],                
cd.Candidate_Relationship as [GRelationship],               
cd.Candidate_Guardian_Address as [Gadress],               
cd.Candidate_Guardian_Telephone as [Gtelephone],                
cd.Candidate_Guardian_Mob as [GMobile],               
cd.Candidate_Guardian_Email as [GEmail],      
CEOD.PCB_Perc,      
CEOD.Physics_Perc,      
CEOD.Chemistry_Perc,      
CEOD.Biology_Perc,      
CEOD.English_Perc,      
CEOD.Entrance_Rank,      
CEOD.Student_Signature,      
CEOD.Parent_Signature,      
      
[IsHostelRequired]=Case when            
CEOD.Is_HostelRequired =1 then ''Yes'' else ''No''  End,       
[IsNRI]=Case when            
CEOD.Is_NRI =1 then ''Yes'' else ''No''  End,      
      
CED.Exam_Name,      
CED.University_Board,      
CED.Reg_No,      
CED.Yearof_Pass,      
CED.Institution_Name,      
CED.Percentage      
           
              
from  dbo.Tbl_Candidate_Personal_Det as pd              
left join dbo.Tbl_Candidate_ContactDetails as cd on pd.Candidate_Id=cd.Candidate_Id              
left join dbo.Tbl_Candidate_EducationDetails CED on pd.Candidate_Id=CED.Candidate_Id        
left join dbo.Tbl_Candidate_Education_OtherDetails CEOD on pd.Candidate_Id=CEOD.Candidate_Id        
left join dbo.Tbl_Student_Registration  as SR on SR.Candidate_Id=pd.Candidate_Id              
left join dbo.Tbl_Course_Category as cc on cc.Course_Category_Id=SR.Course_Category_Id              
left join dbo.Tbl_Department as d on d.Department_Id=SR.Department_Id              
 where pd.Candidate_Id = @Candidate_Id                   
                
end        ');
END;
