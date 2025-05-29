IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_AgentCount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Get_All_AgentCount] --''InActive'',''''      
(      
@Active_Status Varchar(MAX)='''',      
@SearchKeyWord  varchar(max) ,     
@Flag bigint=0,    
@Councellorid  bigint=0    
)      
      
As       
      
begin      
if(@Flag=0)    
begin    
 if(@Active_Status=''Active'')      
begin      
      
      
select distinct count(A.Agent_ID) as ID from [dbo].[Tbl_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
left join Tbl_City Y on A.Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Agent_Status=''Active''       
  AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
      
      
      
end      
else if(@Active_Status=''InActive'')      
begin      
      
select  distinct count(A.Agent_ID) as ID      
from [dbo].[Tbl_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
left join Tbl_City Y on A.Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Agent_Status=''InActive''      
  AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
        
      
      
end      
else      
begin      
      
select distinct count(A.Agent_ID) as ID  from [dbo].[Tbl_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
left join Tbl_City Y on A.Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId      
where A.Delete_Status=0      
  and A.Agent_Status=''Active''       
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
      
      
       
      
end      
end    
    
if(@Flag=1)    
begin    
 if(@Active_Status=''Active'')      
begin      
      
select count(*) as ID from (      
 select distinct (A.Agent_ID) as ID from [dbo].[Tbl_Agent] A      
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
 left join Tbl_City Y on A.Agent_Location=Y.City_Id      
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId      
 where A.Delete_Status=0       
   and A.Agent_Status=''Active''   and Counsellor_Id=@Councellorid     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
    
 Union All    
      
select distinct (A.Temp_Agent_ID) as ID from [dbo].[Tbl_Temp_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID       
Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id      
left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Temp_Agent_Status=''Active''   and Temp_Counsellor_Id=@Councellorid     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))     
)as B --group by ID    
      
end      
else if(@Active_Status=''InActive'')      
begin      
      
select count(*) as ID from (      
 select distinct (A.Agent_ID) as ID from [dbo].[Tbl_Agent] A      
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
 left join Tbl_City Y on A.Agent_Location=Y.City_Id      
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId      
 where A.Delete_Status=0       
   and A.Agent_Status=''InActive''   and Counsellor_Id=@Councellorid     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
    
 Union All    
      
select distinct (A.Temp_Agent_ID) as ID from [dbo].[Tbl_Temp_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID       
Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id      
left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Temp_Agent_Status=''InActive''   and Temp_Counsellor_Id=@Councellorid     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))     
)as B-- group by ID     
        
      
      
end      
else      
begin      
      
select count(*) as ID from (      
 select distinct (A.Agent_ID) as ID from [dbo].[Tbl_Agent] A      
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id      
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id       
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID       
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id      
 left join Tbl_City Y on A.Agent_Location=Y.City_Id      
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId   
 where A.Delete_Status=0       
   and A.Agent_Status=''Active''   and Counsellor_Id=@Councellorid     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))      
    
 Union All    
      
select distinct (A.Temp_Agent_ID) as ID from [dbo].[Tbl_Temp_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID       
Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id      
left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Temp_Agent_Status=''Active''   and Temp_Counsellor_Id=@Councellorid     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))     
)as B --group by ID    
      
      
       
      
end      
end    
if(@Flag=2)    
begin    
 if(@Active_Status=''Active'')      
begin      
      
  
select distinct count(A.Temp_Agent_ID) as ID from [dbo].[Tbl_Temp_Agent] A      
left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id      
Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id       
Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID       
Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id      
left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id      
left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId      
where A.Delete_Status=0       
  and A.Temp_Agent_Status=''Active''    
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%''))     
   
      
end      
   
end    
end 
    ');
END;
