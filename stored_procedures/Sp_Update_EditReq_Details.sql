IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_EditReq_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[Sp_Update_EditReq_Details]-- 3,1
@flag bigint=0,
@Event_Id bigint=0

as

begin


if(@flag=0)
Begin
    
  update Tbl_BudgetPayment set Edit_Req=1 Where Event_Id=@Event_Id


end

if(@flag=1)
Begin
    
  update Tbl_BudgetPayment set Edit_Req=0 Where Event_Id=@Event_Id


end

if(@flag=2)
Begin
    
  update Tbl_BudgetPayment set Edit_Req=3 Where Event_Id=@Event_Id


end
end

   ')
END;
