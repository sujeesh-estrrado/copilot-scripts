IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_JobApplicationDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_All_JobApplicationDetails] --1,5,1                   
(                      
  @Job_Id  varchar(max),              
  @flag bigint=0,            
  @ID bigint=0            
                   
                      
                      
)                      
As                      
                      
Begin              
if(@flag=0)              
begin              
   select [ID],[Job_Id],[Qualification],[Awarding_Body],[Conferment_Date_Of_Awarding] from [Tbl_JobApp_Educational_Background]  where Job_Id=@Job_Id  and Status=0             
end              
  if(@flag=1)              
begin              
   select [ID],[Job_Id],[Qualification],[Awarding_Body],[Conferment_Date_Of_Awarding] from [Tbl_JobApp_Educational_Background]  where Job_Id=@Job_Id and ID=@ID and Status=0           
end             
  if(@flag=2)              
begin              
  update [Tbl_JobApp_Educational_Background] set Status=1 where  Job_Id=@Job_Id and ID=@ID             
end             
  if(@flag=3)              
begin              
  select *,Month([Period_of_Employee_From_Date]) as From_Month,month([Period_of_Employee_To_Date]) as To_Month,            
          Year([Period_of_Employee_From_Date]) as From_Year,year([Period_of_Employee_To_Date]) as To_Year            
          from [Tbl_JobApp_Employment_Background] where [Job_Id]=@Job_Id and ID=@ID  and Status=0           
  end            
    if(@flag=4)              
begin              
  update [Tbl_JobApp_Employment_Background] set [Status]=1 where  Job_Id=@Job_Id and ID=@ID             
end            
   if(@flag=5)              
begin              
select *,convert(varchar,Month([Period_of_Employee_From_Date]))+''-''+convert(varchar,Year([Period_of_Employee_From_Date]))+'' TO ''+          
          convert(varchar,month([Period_of_Employee_To_Date]))+''-''+convert(varchar,Year([Period_of_Employee_To_Date])) as Period_Of_Employment              
          from [Tbl_JobApp_Employment_Background] where [Job_Id]=@Job_Id and Status=0        
end           
   if(@flag=6)              
begin              
select * from[dbo].[Tbl_JobApp_Training_Background] where Status=0 and [Job_Id]=@Job_Id and ID=@ID         
 end         
    if(@flag=7)              
begin              
select * from[dbo].[Tbl_JobApp_Training_Background] where Status=0 and [Job_Id]=@Job_Id        
 end         
     if(@flag=8)              
begin              
Update [dbo].[Tbl_JobApp_Training_Background] set Status=1 where [Job_Id]=@Job_Id and ID=@ID      
 end     
      if(@flag=9)              
begin   
if not exists(select * from [Tbl_JobApp_Attachments] where [Job_Id]=@Job_Id)  
begin  
insert into [dbo].[Tbl_JobApp_Attachments]([Job_Id],[Resume_Name],[Resume_Url],[Passport_Name],[Passport_Url],[Teaching_Permit_Name],[Teaching_Permit_Url],  
            [Medical_Report_Name],[Medical_Report_Url],[Driving_License_Name],[Driving_License_Url],[Status]) values  
   (@Job_Id,'''','''','''','''','''','''','''','''','''','''',0)  
   end  
                     
 end    
   
End
    ')
END
ELSE
BEGIN
EXEC('                     
ALTER procedure Get_All_JobApplicationDetails --1,5,1                   
(                      
  @Job_Id  varchar(max),              
  @flag bigint=0,            
  @ID bigint=0            
                   
                      
                      
)                      
As                      
                      
Begin              
if(@flag=0)              
begin              
   select [ID],[Job_Id],[Qualification],[Awarding_Body],[Conferment_Date_Of_Awarding] from [Tbl_JobApp_Educational_Background]  where Job_Id=@Job_Id  and Status=0             
end              
  if(@flag=1)              
begin              
   select [ID],[Job_Id],[Qualification],[Awarding_Body],[Conferment_Date_Of_Awarding] from [Tbl_JobApp_Educational_Background]  where Job_Id=@Job_Id and ID=@ID and Status=0           
end             
  if(@flag=2)              
begin              
  update [Tbl_JobApp_Educational_Background] set Status=1 where  Job_Id=@Job_Id and ID=@ID             
end             
  if(@flag=3)              
begin              
  select *,Month([Period_of_Employee_From_Date]) as From_Month,month([Period_of_Employee_To_Date]) as To_Month,            
          Year([Period_of_Employee_From_Date]) as From_Year,year([Period_of_Employee_To_Date]) as To_Year            
          from [Tbl_JobApp_Employment_Background] where [Job_Id]=@Job_Id and ID=@ID  and Status=0           
  end            
    if(@flag=4)              
begin              
  update [Tbl_JobApp_Employment_Background] set [Status]=1 where  Job_Id=@Job_Id and ID=@ID             
end            
   if(@flag=5)              
begin              
select *,convert(varchar,Month([Period_of_Employee_From_Date]))+''-''+convert(varchar,Year([Period_of_Employee_From_Date]))+'' TO ''+          
          convert(varchar,month([Period_of_Employee_To_Date]))+''-''+convert(varchar,Year([Period_of_Employee_To_Date])) as Period_Of_Employment              
          from [Tbl_JobApp_Employment_Background] where [Job_Id]=@Job_Id and Status=0        
end           
   if(@flag=6)              
begin              
select * from[dbo].[Tbl_JobApp_Training_Background] where Status=0 and [Job_Id]=@Job_Id and ID=@ID         
 end         
    if(@flag=7)              
begin              
select * from[dbo].[Tbl_JobApp_Training_Background] where Status=0 and [Job_Id]=@Job_Id        
 end         
     if(@flag=8)              
begin              
Update [dbo].[Tbl_JobApp_Training_Background] set Status=1 where [Job_Id]=@Job_Id and ID=@ID      
 end     
      if(@flag=9)              
begin   
if not exists(select * from [Tbl_JobApp_Attachments] where [Job_Id]=@Job_Id)  
begin  
insert into [dbo].[Tbl_JobApp_Attachments]([Job_Id],[Resume_Name],[Resume_Url],[Passport_Name],[Passport_Url],[Teaching_Permit_Name],[Teaching_Permit_Url],  
            [Medical_Report_Name],[Medical_Report_Url],[Driving_License_Name],[Driving_License_Url],[Status]) values  
   (@Job_Id,'''','''','''','''','''','''','''','''','''','''',0)  
   end  
                     
 end    
   
End


')
END