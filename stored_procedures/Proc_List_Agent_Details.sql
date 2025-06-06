-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_List_Agent_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_List_Agent_Details] --''Active'',1000000,1,''''
(
@Active_Status Varchar(MAX)='''',
@PageSize bigint=0,
@CurrentPage bigint=0,
@SearchKeyWord  varchar(max)=''''

)

As 

begin
if(@Active_Status=''Active'')
begin


select distinct A.Agent_ID,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name)as Agent_Name,A.Agent_RegNo,T.Country,A.Agent_Mob,
S.State_Name as  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email) as Agent_Email,Isnull(Sum(Amount),0) as Commission,
A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A
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
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')
  )

group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,
S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id
order by ID desc
 
 OFFSET @pagesize * (@CurrentPage - 1) ROWS
      FETCH NEXT @pagesize ROWS ONLY

end
else if(@Active_Status=''InActive'')
begin

select  distinct A.Agent_ID,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name)as Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,
S.State_Name  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email)as Agent_Email,Isnull(Sum(Amount),0) as Commission,
A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A
inner join Tbl_Agent_Category C on  C.Category_Id=A.Agent_Category_Id
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
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')
  )
   group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,
S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id 
order by ID desc
 
 OFFSET @pagesize * (@CurrentPage - 1) ROWS
      FETCH NEXT @pagesize ROWS ONLY

end
else
begin

select distinct A.Agent_ID,A.Agent_ID as ID,A.Agent_Category_Id,C.Category_Name,UPPER(A.Agent_Name) as Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,
S.State_Name  Agent_Area,Y.City_Name as Agent_Location,Lower(A.Agent_Email)as Agent_Email,Isnull(Sum(Amount),0) as Commission,
A.Agent_Status,AU.User_Id from [dbo].[Tbl_Agent] A
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
  or A.Agent_Email LIKE CONCAT(''%'',@Searchkeyword,''%'')
  )
group by  A.Agent_ID,A.Agent_Category_Id,C.Category_Name,A.Agent_Name,A.Agent_RegNo,T.Country,Agent_Mob,
S.State_Name,Y.City_Name,A.Agent_Email,A.Agent_Status,AU.User_Id 
order by ID desc
 
 OFFSET @pagesize * (@CurrentPage - 1) ROWS
      FETCH NEXT @pagesize ROWS ONLY
end

End
    ')
END;
GO
