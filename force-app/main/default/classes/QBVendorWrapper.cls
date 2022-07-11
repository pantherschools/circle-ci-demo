/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-05-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBVendorWrapper {
    public PrimaryEmailAddr PrimaryEmailAddr;
	public WebAddr WebAddr;
	public PrimaryPhone PrimaryPhone;
	public String DisplayName;	//Dianne's Auto Shop
	public String Suffix;	//Sr.
	public String Title;	//Ms.
	public Mobile Mobile;
	public String FamilyName;	//Bradley
	public String TaxIdentifier;	//99-5688293
	public String AcctNum;	//35372649
	public String CompanyName;	//Dianne's Auto Shop
	public BillAddr BillAddr;
	public String GivenName;	//Dianne
	public String PrintOnCheckName;	//Dianne's Auto Shop
	public class PrimaryEmailAddr {
		public String Address;	//dbradley@myemail.com
	}
	public class WebAddr {
		public String URI;	//http://DiannesAutoShop.com
	}
	public class PrimaryPhone {
		public String FreeFormNumber;	//(650) 555-2342
	}
	public class Mobile {
		public String FreeFormNumber;	//(650) 555-2000
	}
	public class BillAddr {
		public String City;	//Millbrae
		public String Country;	//U.S.A
		public String Line3;	//29834 Mustang Ave.
		public String Line2;	//Dianne Bradley
		public String Line1;	//Dianne's Auto Shop
		public String PostalCode;	//94030
		public String CountrySubDivisionCode;	//CA
	}
}
