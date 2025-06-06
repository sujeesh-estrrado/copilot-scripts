IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Counsellor_PageMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_Counsellor_PageMapping] --3,60950                  
(                  
@flag bigint=0,                  
@PageMapping_Id  bigint=0,                
@Counsellor_Id bigint=0,                
@Page_Id bigint=0,                
@Created_By  bigint=0,        
@InstapageURL_Id  bigint=0,    
@Nationality_Id bigint=0 ,
@AppType varchar(10)='''',
@AppLevel varchar(10)='''',
@State_Id bigint=0,  
@Program_Id bigint=0,  
@Agent_Id bigint=0,  
@Type varchar(25)='''',
@ActiveStatus bigint=0

)                  
AS                  
                  
BEGIN                  
if(@flag=0)                  
 begin                  
                
 IF NOT EXISTS (SELECT * FROM Tbl_Counsellor_PageMapping             
                   WHERE Page_Id = @Page_Id            
                   AND Counsellor_Id = @Counsellor_Id  
                   --AND  InstapageURL_Id=@InstapageURL_Id 
                   AND Nationality_Id=@Nationality_Id   
                   and state_id =@State_Id
                   and Program_id=@Program_Id
                   and Agent_id=@Agent_Id
                   and Type =@Type
                   and ActiveStatus =@ActiveStatus
                   )            
 BEGIN            
   Insert into Tbl_Counsellor_PageMapping (Counsellor_Id,Page_Id,InstapageURL_Id,Nationality_Id,Created_By,created_Date,Counter,Delete_Status,state_id,Program_id,Agent_id,Type,ActiveStatus)                
   values(@Counsellor_Id,@Page_Id,@InstapageURL_Id,@Nationality_Id,@Created_By,getdate(),(select min(Counter) from Tbl_Counsellor_PageMapping where Delete_Status = 0),0,@State_Id,@Program_Id,@Agent_Id,@Type,@ActiveStatus)               
 END            
 else            
 begin            
           
  update Tbl_Counsellor_PageMapping            
  set Delete_Status = 0  ,          
 Counter = (select min(Counter) from Tbl_Counsellor_PageMapping where Delete_Status = 0 and  Page_Id = @Page_Id  )          
  where  Page_Id = @Page_Id            
                   AND Counsellor_Id = @Counsellor_Id            
 end            
 end                 
               
 if(@flag=1)                  
 begin                  
                
    select PM.Counsellor_Id,PageMapping_Id,concat(E.Employee_FName,'' '',E.Employee_LName)as CounsellorName,              
  --case when Page_Id=1 then ''Welcome Page'' when Page_Id=2 then ''Landingi'' end as PageName,  
  CASE 
    WHEN Page_Id = 1 AND PM.Type = ''Lead'' THEN ''Add New lead''
    WHEN Page_Id = 1 AND PM.Type = ''Application'' THEN ''Online Application''
    WHEN Page_Id = 2 AND PM.Type = ''Lead'' THEN ''Instapage''
    WHEN Page_Id = 2 AND PM.Type = ''Application'' THEN ''Landing Page''
    WHEN Page_Id = 3 AND PM.Type = ''Lead'' THEN ''Excel upload''
    WHEN Page_Id = 3 AND PM.Type = ''Application'' THEN ''New Application page''
    --ELSE ''Other''
END AS PageName,
  concat(E.Employee_FName,'' '',EM.Employee_LName)as Created_By,PM.created_Date ,PM.InstapageURL_Id,  
  --(Select InstapageURL_Name from Tbl_InstapageURL where InstapageURL_Id=PM.InstapageURL_Id)  as InstapageURLName ,    
    (Select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=PM.InstapageURL_Id)  as InstapageURLName ,   
  PM.Nationality_Id,N.Country as NationalityName    ,PM.state_id,s.State_Name,PM.Program_id,D.Department_name,PM.Agent_id,A.AGENT_NAME,PM.Type , PM.ActiveStatus
  from Tbl_Counsellor_PageMapping PM              
  left join Tbl_Employee E on E.Employee_Id=PM.Counsellor_Id              
  left join Tbl_Employee EM on EM.Employee_Id=PM.Created_By     
 -- left join Tbl_Nationality N on N.Nationality_Id =  PM.Nationality_Id    
  left join Tbl_Country N on n.Country_Id =  PM.Nationality_Id    
     left join [[Tbl_State]]] s on s.State_Id =  PM.state_Id 
      left join Tbl_Department D on D.Department_Id =  PM.Program_id   
      left join Tbl_Agent A on A.Agent_ID = PM.Agent_id
  where E.Employee_Status =0 and PM.Delete_Status=0     order by PageMapping_Id desc
          
                 
 end                 
  if(@flag=2)                  
 begin                  
                
  update Tbl_Counsellor_PageMapping               
  set Delete_Status = 1            
                
  where PageMapping_Id=@PageMapping_Id              
                 
 end                
  if(@flag=3)                  
 begin                  
                
  select Counsellor_Id,InstapageURL_Id,Nationality_Id from Tbl_Counsellor_PageMapping               
                
  where Page_Id=@Page_Id and Delete_Status=0            
                 
 end               
 if(@flag=4)                  
 begin                  
  update Tbl_Counsellor_PageMapping               
  set Delete_Status = 1            
  where Page_Id=@Page_Id  and Counsellor_Id = @Counsellor_Id --and InstapageURL_Id=@InstapageURL_Id        
 end                
 if(@flag=5)      --Update counter            
 begin                  
              
  update Tbl_Counsellor_PageMapping set Counter=0 where Counter is null            
            
  update Tbl_Counsellor_PageMapping               
  set Counter = Counter+1            
  where Counsellor_Id = @Counsellor_Id            
    --and Page_Id=@Page_Id              
 end  
 if(@flag=6)                  
 begin                  
  update Tbl_Counsellor_PageMapping               
  set ActiveStatus = @ActiveStatus            
  where PageMapping_Id=@PageMapping_Id 
 end          
End
    ')
END
