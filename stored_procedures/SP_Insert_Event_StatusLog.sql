IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Event_StatusLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_Insert_Event_StatusLog]
(
     @Event_Id  bigint,
	 @Employee_Id  bigint,
	 @Status   varchar (max),
	 @Remark   varchar (max)
	 
)
As

Begin

	Insert into Tbl_Event_StatusLog
		   (Event_Id,
		   Employee_Id,
		   Action_Date,
		   Status,
		   Remark
		   
		   )
	values(@Event_Id,
	       @Employee_Id,
		   getdate(),
		   @Status,
		   @Remark
		   )
	
	
End 
   ');
END;
