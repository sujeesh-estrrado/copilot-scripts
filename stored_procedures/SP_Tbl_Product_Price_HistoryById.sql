IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Product_Price_HistoryById]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Product_Price_HistoryById]  
 @Product_Id bigint      
AS      
BEGIN      
    
select PP.*,P.Product_Name from [Tbl_Product_Price] PP left join dbo.Tbl_Products P on PP.Product_Id=P.Product_Id   
where PP.price_DelStatus=0 AND PP.Product_Id=@Product_Id and PP.IsCompleted=1  
END
    ')
END
