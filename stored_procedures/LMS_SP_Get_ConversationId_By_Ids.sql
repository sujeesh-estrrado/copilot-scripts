IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ConversationId_By_Ids]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_ConversationId_By_Ids]
@Ids varchar(1000)  
As  
Begin  
Select * from(Select  
con1.Conversation_Id,  
ISNULL(con1.Group_Id,0) As GroupId,  
Ids=  
substring((SELECT distinct ( '','' + cast(ID as varchar(10))+cast (Status as varchar(1)) ) From                              
(select   
Chat.Send_User_Id ID,   
Chat.Send_User_Status Status  
from dbo.LMS_Tbl_Conversation Con inner join dbo.LMS_Tbl_Chat Chat  
 on Con.Conversation_Id = Chat.Conversation_Id   
where  Con.Conversation_Id=Con1.Conversation_Id   
union  
select   
Rec.Receiver_User_Id ID,   
Rec.Receiver_User_Status Status   
from dbo.LMS_Tbl_Conversation Con inner join dbo.LMS_Tbl_Chat Chat  
 on Con.Conversation_Id = Chat.Conversation_Id  
inner join dbo.LMS_Tbl_Chat_Receiver Rec on Chat.Chat_Id = Rec.Chat_Id  
where  Con.Conversation_Id=Con1.Conversation_Id  
) temp  
FOR XML PATH( '''' )),2,1000)  
from dbo.LMS_Tbl_Conversation Con1 inner join dbo.LMS_Tbl_Chat Chat1  
 on Con1.Conversation_Id = Chat1.Conversation_Id  
inner join dbo.LMS_Tbl_Chat_Receiver Rec on Chat1.Chat_Id = Rec.Chat_Id  
group by Con1.Conversation_Id,Con1.Group_Id) Temp1  
Where Ids=@Ids   and  GroupId=0
End
    ')
END
