IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_fixed_payment_method]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_fixed_payment_method]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	select Id,Name, paySupports
	from [dbo].[fixed_payment_method]
	
END  

    ')
END
