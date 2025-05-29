IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_PaymentMethods]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_PaymentMethods]
(@flag int = 0,
@name varchar(150)=0,
@description varchar(150)='''',
@odr int=100,
@active int=1,
@id int =0)
AS
BEGIN
	if @flag=1
	begin
		select * from fixed_payment_method where active = 1 order by name
	end
	if @flag=2 -- Add New Payment Method
	begin
		INSERT INTO fixed_payment_method
           ([code]
           ,[name]
           ,[description]
           ,[odr]
           ,[active]
           ,[paySupports])
     VALUES
           (0,@name,@description,@odr,@active,''1,2,3,4,5'')
	end
	if @flag = 3
	begin
		UPDATE [dbo].[fixed_payment_method]
		SET [name] = @name
		WHERE id= @id
	 end
end
    ');
END;
