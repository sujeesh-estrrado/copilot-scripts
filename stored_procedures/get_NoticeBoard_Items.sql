IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[get_NoticeBoard_Items]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[get_NoticeBoard_Items]        
as        
begin        
select NoticeBoard_id,Desc1,Desc2,Desc3,Desc4,Desc5,Desc6 from dbo.tbl_NoticeBoard        
end 

   ')
END;
