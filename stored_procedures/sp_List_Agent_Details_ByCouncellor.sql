IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_List_Agent_Details_ByCouncellor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_List_Agent_Details_ByCouncellor]-- ''Active'',1000000,1,''''    
(    
@Active_Status Varchar(MAX)='''',    
@PageSize bigint=0,    
@CurrentPage bigint=0,    
@SearchKeyWord  varchar(max)='''',   
@Councellorid bigint=0  ,
@flag bigint=0
)    
    
As     
    
begin    
if (@flag=0)
begin
  if(@Active_Status=''Active'')    
begin    
    
    
 (select distinct A.Agent_ID,Counsellor_Id,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name)as Agent_Name,A.Agent_RegNo,T.Country,A.Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID     
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Counsellor_Id=@Councellorid  
   and A.Agent_Status=''Active''     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,    
 S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id  ,PSO_Status,Counsellor_Id  
)  
     
   
Union all  
 ( select distinct A.Temp_Agent_ID,Temp_Counsellor_Id,A.Temp_Agent_ID as ID,A.Temp_Agent_Category_Id,C.Category_Name,UPPER(A.Temp_Agent_Name)as Agent_Name,A.Temp_Agent_RegNo,T.Country,A.Temp_Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Temp_Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Temp_Agent_Status,AU.User_Id from [dbo].[Tbl_Temp_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID     
 Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Temp_Counsellor_Id=@Councellorid  
   and A.Temp_Agent_Status=''Active''     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Temp_Agent_ID,A.Temp_Agent_Category_Id,C.Category_Name,A.Temp_Agent_Name,A.Temp_Agent_RegNo,T.Country,Temp_Agent_Mob,    
 S.State_Name,Y.City_Name,A.Temp_Agent_Email,A.Temp_Agent_Status,AU.User_Id  ,PSO_Status,Temp_Counsellor_Id  
 )  
 order by ID desc    
     
 OFFSET @pagesize * (@CurrentPage - 1) ROWS    
      FETCH NEXT @pagesize ROWS ONLY    
   
end    
else if(@Active_Status=''InActive'')    
begin    
    
    
    
 (select distinct A.Agent_ID,Counsellor_Id,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name)as Agent_Name,A.Agent_RegNo,T.Country,A.Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID     
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Counsellor_Id=@Councellorid  
   and A.Agent_Status=''InActive''     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,    
 S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id  ,PSO_Status,Counsellor_Id  
)  
     
   
Union all  
 ( select distinct A.Temp_Agent_ID,Temp_Counsellor_Id,A.Temp_Agent_ID as ID,A.Temp_Agent_Category_Id,C.Category_Name,UPPER(A.Temp_Agent_Name)as Agent_Name,A.Temp_Agent_RegNo,T.Country,A.Temp_Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Temp_Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Temp_Agent_Status,AU.User_Id from [dbo].[Tbl_Temp_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID     
 Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Temp_Counsellor_Id=@Councellorid  
   and A.Temp_Agent_Status=''InActive''     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Temp_Agent_ID,A.Temp_Agent_Category_Id,C.Category_Name,A.Temp_Agent_Name,A.Temp_Agent_RegNo,T.Country,Temp_Agent_Mob,    
 S.State_Name,Y.City_Name,A.Temp_Agent_Email,A.Temp_Agent_Status,AU.User_Id  ,PSO_Status,Temp_Counsellor_Id  
 )  
 order by ID desc    
     
 OFFSET @pagesize * (@CurrentPage - 1) ROWS    
      FETCH NEXT @pagesize ROWS ONLY    
   
    
end    
else    
begin    
    
  
 (select distinct A.Agent_ID,Counsellor_Id,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name)as Agent_Name,A.Agent_RegNo,T.Country,A.Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Agent_ID     
 Left join [[Tbl_State]]] S on A.Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Counsellor_Id=@Councellorid  
   and A.Agent_Status=''Active''     
   AND (A.Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,    
 S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id  ,PSO_Status,Counsellor_Id  
)  
     
   
Union all  
 ( select distinct A.Temp_Agent_ID,Temp_Counsellor_Id,A.Temp_Agent_ID as ID,A.Temp_Agent_Category_Id,C.Category_Name,UPPER(A.Temp_Agent_Name)as Agent_Name,A.Temp_Agent_RegNo,T.Country,A.Temp_Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Temp_Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,   
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Temp_Agent_Status,AU.User_Id from [dbo].[Tbl_Temp_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID     
 Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId    
 where A.Delete_Status=0   and Temp_Counsellor_Id=@Councellorid  
   and A.Temp_Agent_Status=''Active''     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Temp_Agent_ID,A.Temp_Agent_Category_Id,C.Category_Name,A.Temp_Agent_Name,A.Temp_Agent_RegNo,T.Country,Temp_Agent_Mob,    
 S.State_Name,Y.City_Name,A.Temp_Agent_Email,A.Temp_Agent_Status,AU.User_Id  ,PSO_Status,Temp_Counsellor_Id  
 )  
 order by ID desc    
     
 OFFSET @pagesize * (@CurrentPage - 1) ROWS    
      FETCH NEXT @pagesize ROWS ONLY    
end    
end  
if (@flag=1)
begin
  if(@Active_Status=''Active'')    
begin    
    
 select distinct A.Temp_Agent_ID as Agent_ID,Temp_Counsellor_Id as Counsellor_Id,A.Temp_Agent_ID as ID,
 A.Temp_Agent_Category_Id as Agent_Category_Id,C.Category_Name,UPPER(A.Temp_Agent_Name)as Agent_Name,
 A.Temp_Agent_RegNo as Agent_RegNo,T.Country,A.Temp_Agent_Mob as Agent_Mob,    
 S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Temp_Agent_Email) as Agent_Email,  
 Isnull(Sum(Amount),0) as Commission,concat(Employee_Fname,'' '',Employee_Lname) as Counsellor , 
 case when PSO_Status is null then ''Pending'' when PSO_Status=0 then ''Pending''when PSO_Status=1 then ''Approved'' end as PSO_Status,  
 A.Temp_Agent_Status as Agent_Status,AU.User_Id from [dbo].[Tbl_Temp_Agent] A    
 left join Tbl_Agent_Category C on  C.Category_Id=A.Temp_Agent_Category_Id    
 Left join Tbl_Country T on T.Country_Id=A.Temp_Agent_Country_Id     
 Left join Tbl_Agent_User AU on AU.Agent_Id=A.Temp_Agent_ID     
 Left join [[Tbl_State]]] S on A.Temp_Agent_Area=S.State_Id    
 left join Tbl_City Y on A.Temp_Agent_Location=Y.City_Id    
 left join Tbl_Agent_Settlement Se on A.Temp_Agent_ID=Se.AgentId    
 left join Tbl_Employee EY on EY.Employee_Id=Temp_Counsellor_Id
 where A.Delete_Status=0    
   and A.Temp_Agent_Status=''Active''     
   AND (A.Temp_Agent_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')      
   or C.Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_RegNo LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Mob LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   or A.Temp_Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')    
   )    
    
 group by  A.Temp_Agent_ID,A.Temp_Agent_Category_Id,C.Category_Name,A.Temp_Agent_Name,A.Temp_Agent_RegNo,T.Country,Temp_Agent_Mob,    
 S.State_Name,Y.City_Name,A.Temp_Agent_Email,A.Temp_Agent_Status,AU.User_Id  ,PSO_Status,Temp_Counsellor_Id  ,Employee_Fname,Employee_Lname
 
 order by ID desc    
     
 OFFSET @pagesize * (@CurrentPage - 1) ROWS    
      FETCH NEXT @pagesize ROWS ONLY    
   
end    
  
end
End    
    ');
END;
