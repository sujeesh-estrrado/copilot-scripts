IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_AgentDetails_by_AgentID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[Sp_Get_All_AgentDetails_by_AgentID] --1          
(    
@Agent_Id BIGINT    
)                  
                  
AS                  
BEGIN                  
 if exists(select Temp_Agent_ID from Tbl_Temp_Agent WHERE  Temp_Agent_ID = @Agent_ID and Delete_Status=0 )  
 begin               
  select A.Temp_Agent_ID as Agent_ID,A.Temp_Agent_Category_Id as Agent_Category_Id, Contract_Expiry, 
  C.Category_Name as Category_Name,A.Temp_Agent_Name as Agent_Name,A.Temp_Agent_RegNo as Agent_RegNo,    
  T.Country as Country,T.Country_Id as Country_Id,A.Temp_Agent_Country_Id as Agent_Country_Id,  
  A.Temp_Agent_Mob as Agent_Mob,A.Temp_Agent_Home as Agent_Home,Temp_Counsellor_Id as Counsellor_Id,    
  A.Temp_Agent_Area as Agent_Area,A.Temp_Agent_Email as Agent_Email,A.Temp_Agent_Status as Agent_Status,  
  A.Temp_Agent_Address as Agent_Address,A.Temp_Nationality as Nationality,    
  A.Temp_Agent_Location as Agent_Location from [dbo].[Tbl_Temp_Agent] A    
  Inner join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id    
  Inner join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id    
  where A.Temp_Agent_ID=@Agent_Id and A.Delete_Status=0              
 end   
 else  
 begin               
  select A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo, Contract_Expiry,   
  T.Country,T.Country_Id,A.Agent_Country_Id,A.Agent_Mob,A.Agent_Home,Counsellor_Id,    
  A.Agent_Area,A.Agent_Email,A.Agent_Status,A.Agent_Address,A.Nationality,    
  A.Agent_Location from [dbo].[Tbl_Agent] A    
  Inner join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id    
  Inner join Tbl_Country T on T.Country_Id=A.Agent_Country_Id    
  where A.Agent_ID=@Agent_Id and A.Delete_Status=0              
 end                  
END     
    ');
END;
