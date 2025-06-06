IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Programmes]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[Sp_Get_All_Programmes]           
--[Sp_Get_All_Programmes]1, 0, 15          
@flag bigint=0,        
@Program_Type_Id bigint=0,          
@Faculty bigint=0 ,    
@Modeofstudy bigint=0    
as              
begin        
if(@flag=0)        
begin        
  Select distinct Department_Id,Department_Name,GraduationTypeId from Tbl_Department            
  where  Department_Status=0 and Active_Status=''Active'' and Delete_Status=0              
  and (Program_Type_Id=@Program_Type_Id or @Program_Type_Id=0)            
  and (GraduationTypeId = @Faculty or @Faculty =0 )          
  order by Department_Name         
 end        
 if(@flag=1)        
begin        
  Select distinct Department_Id,concat(Department_Name,'' - '',Course_Code)as Department_Name,GraduationTypeId from Tbl_Department            
  where  Department_Status=0 and Active_Status=''Active'' and Delete_Status=0              
  and (Program_Type_Id=@Program_Type_Id)            
  and (GraduationTypeId = @Faculty ) and Online_checkstatus=1         
  order by Department_Name         
 end        
 if(@flag=2)        
begin        
  Select distinct Department_Id,concat(Department_Name,'' - '',Course_Code)as Department_Name,GraduationTypeId from Tbl_Department            
  where  Department_Status=0 and Active_Status=''Active'' and Delete_Status=0              
  and (Program_Type_Id=@Program_Type_Id or @Program_Type_Id=0)            
  and (GraduationTypeId = @Faculty or @Faculty =0 ) and (@Modeofstudy=0 or Modeofstudy=@Modeofstudy)    and Online_checkstatus=1        
  order by Department_Name         
 end       
 if(@flag=3)        
begin        
  Select distinct Department_Id,Department_Name,GraduationTypeId from Tbl_Department            
  where  Department_Status=0 and Active_Status=''Active'' and Delete_Status=0     --and Online_checkstatus=1        
  order by Department_Name         
 end       
      
end 
    ')
END
