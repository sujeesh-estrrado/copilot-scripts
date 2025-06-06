-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Faculty_Report_Programme_Sales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
      CREATE PROCEDURE [dbo].[Get_Faculty_Report_Programme_Sales]            
(@flag bigint=1,          
@course_Level_id BIGINT=0,    
@Dropdownvalue varchar(50)=null,   
@fromdate datetime = NULL,              
@Todate datetime = NULL )            
AS            
BEGIN                       
            
   ------Factulty-------Programme          
   if(@flag=1)                      
 begin                
          
 if(@course_Level_id > 0)                      
 begin   
    if(@Dropdownvalue = ''Pending'')  
  begin    
 select  D.Department_Id as CID ,D.Department_Name as CName,        
count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD         
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id        
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id        
Right Join Tbl_Department D on D.Department_Id=NA.Department_Id         
where  CPD.RegDate  between  @fromdate and @Todate and ApplicationStatus=''Pending'' and NA.Course_Level_Id=@course_Level_id  
Group by  CL.Course_Level_Name ,CL.Course_Level_Id ,D.Department_Name ,D.Department_Id    
End  
   if(@Dropdownvalue = ''Verified'')  
  begin    
 select  D.Department_Id as CID ,D.Department_Name as CName,        
count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD         
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id        
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id        
Right Join Tbl_Department D on D.Department_Id=NA.Department_Id         
where  CPD.RegDate  between  @fromdate and @Todate and ApplicationStatus=''Verified'' and NA.Course_Level_Id=@course_Level_id  
Group by  CL.Course_Level_Name ,CL.Course_Level_Id ,D.Department_Name ,D.Department_Id    
End  
  
  if(@Dropdownvalue = ''Conditional_Admission'')  
  begin    
 select  D.Department_Id as CID ,D.Department_Name as CName,        
count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD         
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id        
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id        
Right Join Tbl_Department D on D.Department_Id=NA.Department_Id         
where  CPD.RegDate  between  @fromdate and @Todate and ApplicationStatus=''Conditional_Admission'' and NA.Course_Level_Id=@course_Level_id  
Group by  CL.Course_Level_Name ,CL.Course_Level_Id ,D.Department_Name ,D.Department_Id    
End  
  
 if(@Dropdownvalue = ''Preactivated'')  
  begin    
 select  D.Department_Id as CID ,D.Department_Name as CName,        
count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD         
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id        
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id        
Right Join Tbl_Department D on D.Department_Id=NA.Department_Id         
where  CPD.RegDate  between  @fromdate and @Todate and ApplicationStatus=''Preactivated'' and NA.Course_Level_Id=@course_Level_id  
Group by  CL.Course_Level_Name ,CL.Course_Level_Id ,D.Department_Name ,D.Department_Id    
End  
  
 if(@Dropdownvalue = ''Completed'')  
  begin    
 select  D.Department_Id as CID ,D.Department_Name as CName,        
count(distinct  CPD.Candidate_Id) as Enquires  
from Tbl_Candidate_Personal_Det CPD         
Left Join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id        
Right Join Tbl_Course_Level CL on CL.Course_Level_Id=NA.Course_Level_Id        
Right Join Tbl_Department D on D.Department_Id=NA.Department_Id         
where  CPD.RegDate  between  @fromdate and @Todate and ApplicationStatus=''Completed'' and NA.Course_Level_Id=@course_Level_id  
Group by  CL.Course_Level_Name ,CL.Course_Level_Id ,D.Department_Name ,D.Department_Id    
End  
          
 end     
                     
  end             
END 
    ')
END;
GO
