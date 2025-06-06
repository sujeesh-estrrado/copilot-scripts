
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Faculty_Report_Sales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Get_Faculty_Report_Sales]            
(@flag bigint=1,             
@Dropdownvalue varchar(50)=null,          
@fromdate datetime = NULL,              
@Todate datetime = NULL )            
AS            
BEGIN            
                  
            
  -------------------Factulty          
   if(@flag=1)  
   begin  
   if(@Dropdownvalue = ''Pending'')  
  begin      
  select  Cl.Course_Level_Id  as CID,CL.Course_Level_Name as CName, count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD             
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id            
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id             
where CPD.RegDate  between  @fromdate and @Todate  and ApplicationStatus=''Pending''          
Group by  CL.Course_Level_Name ,CL.Course_Level_Id    
    end    
  if(@Dropdownvalue = ''Verified'')  
  begin      
  select  Cl.Course_Level_Id  as CID,CL.Course_Level_Name as CName, count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD             
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id            
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id             
where CPD.RegDate  between  @fromdate and @Todate  and ApplicationStatus=''Verified''          
Group by  CL.Course_Level_Name ,CL.Course_Level_Id    
    end    
  if(@Dropdownvalue = ''Conditional_Admission'')  
  begin      
  select  Cl.Course_Level_Id  as CID,CL.Course_Level_Name as CName, count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD             
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id            
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id             
where CPD.RegDate  between  @fromdate and @Todate  and ApplicationStatus=''Conditional_Admission''          
Group by  CL.Course_Level_Name ,CL.Course_Level_Id    
    end    
  if(@Dropdownvalue = ''Preactivated'')  
  begin      
  select  Cl.Course_Level_Id  as CID,CL.Course_Level_Name as CName, count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD             
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id            
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id             
where CPD.RegDate  between  @fromdate and @Todate  and ApplicationStatus=''Preactivated''          
Group by  CL.Course_Level_Name ,CL.Course_Level_Id    
    end   
  if(@Dropdownvalue = ''Completed'')  
  begin      
  select  Cl.Course_Level_Id  as CID,CL.Course_Level_Name as CName, count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD             
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id            
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id             
where CPD.RegDate  between  @fromdate and @Todate  and ApplicationStatus=''Completed''          
Group by  CL.Course_Level_Name ,CL.Course_Level_Id    
    end   
  
 end     
END 


    ')
END
