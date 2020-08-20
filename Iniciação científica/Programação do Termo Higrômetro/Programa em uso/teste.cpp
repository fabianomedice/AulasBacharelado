//
// interface do nosso objeto COM
//
__interface __declspec(uuid("977BF132-B6B6-4d70-88BD-C427A2724B48"))
//ITest : IUnknown
{
   HRESULT WINAPI Method1(BSTR str, ULONG ul);
};

//
// Objeto que implementa a class ITest
//
class CTest : public ITest
{
   DWORD m_ref;
public:
   CTest()
   {
      m_ref = 0;
   }

   //
   // implementação de IUnknown
   //
   STDMETHOD(QueryInterface)(REFIID riid, void **ppvObject)
   {
      if(InlineIsEqualUnknown(riid))
      {
         AddRef();
         *ppvObject = static_cast<IUnknown*>(this);
         return S_OK;
      }
      else if(InlineIsEqualGUID(riid, __uuidof(ITest)))
      {
         AddRef();
         *ppvObject = static_cast<ITest*>(this);
         return S_OK;
      }
      
      return E_NOINTERFACE;
   }

   STDMETHOD_(ULONG,AddRef)()
   {
      return ++m_ref;
   }

   STDMETHOD_(ULONG,Release)()
   {
      DWORD ref = --m_ref;

      if(ref == 0)
         delete this;

      return ref;
   }

   //
   // implementação de ITest
   //
   STDMETHOD(Method1)(BSTR str, ULONG ul)
   {
      MessageBoxW(NULL, str, L"", MB_ICONEXCLAMATION);
      return S_OK;
   }
};
//
// Class Factory para o nosso obejto
//
class CTestClassFactory : public IClassFactory
{
   DWORD m_ref;
public:
   CTestClassFactory()
   {
      m_ref = 0;
   }

   //
   // quando o objeto é registrado, a runtime do Microsoft COM 
   // chama a função GetClassObject exportada pela DLL do objeto.
   // como vamos fazer tudo na mão agora, vamos criar esse helper
   //
   static HRESULT CreateClassFactory(REFIID riid, void **ppv)
   {
      HRESULT hr;
      IUnknown* p;

      try
      {
         p = new CTestClassFactory();
      }
      catch(...)
      {
         return E_OUTOFMEMORY;
      }

      p->AddRef();

      hr = p->QueryInterface(riid, ppv);

      p->Release();

      return hr;
   }

   //
   // implementação do IClassFactory
   //
   STDMETHOD(CreateInstance)(IUnknown *pUnkOuter, REFIID riid, void **ppvObject)
   {
      HRESULT hr;
      IUnknown* pUnk;

      if(pUnkOuter)
         return CLASS_E_NOAGGREGATION;

      try
      {
         //
         // pelo padrão C++, se o new falha uma exceção é disparada
         //
         pUnk = new CTest();
      }
      catch(...)
      {
         return E_OUTOFMEMORY;
      }
      
      pUnk->AddRef();

      hr = pUnk->QueryInterface(riid, ppvObject);

      
      pUnk->Release();

      return hr;
   }
   STDMETHOD(LockServer)(BOOL fLock)
   {
      return S_OK;
   }

   //
   // implementação de IUnknown
   //
   STDMETHOD(QueryInterface)(REFIID riid, void **ppvObject)
   {
      if(InlineIsEqualUnknown(riid))
      {
         AddRef();
         *ppvObject = this;
         return S_OK;
      }
      else if(InlineIsEqualGUID(riid, IID_IClassFactory))
      {
         AddRef();
         *ppvObject = static_cast<IClassFactory*>(this);
         return S_OK;
      }

      return E_NOINTERFACE;
   }

   STDMETHOD_(ULONG,AddRef)()
   {
      return ++m_ref;
   }

   STDMETHOD_(ULONG,Release)()
   {
      DWORD ref = --m_ref;

      if(ref == 0)
         delete this;

      return ref;
   }
};

//
// E no sétimo dia Deus disse: "int main"
//
int main()
{
   HRESULT hr;
   BSTR bstr;
   IClassFactory* pClassFactory;
   ITest* pTest;

   //
   // criando o class factory
   //
   hr = CTestClassFactory::CreateClassFactory(IID_IClassFactory, (void**)&pClassFactory);
   if(FAILED(hr))
      return hr;

   //
   // solicitando gentilmente para que ele crie um objeto daquele tipo
   //
   hr = pClassFactory->CreateInstance(NULL, __uuidof(ITest), (void**)&pTest);
   if(FAILED(hr))
   {
      pClassFactory->Release();
      return hr;
   }

   //
   // usando o objeto
   //
   bstr = SysAllocString(L"Uma string bem legal");
   
   hr = pTest->Method1(bstr, 20);
   
   SysFreeString(bstr);

   if(FAILED(hr))
   {
      pClassFactory->Release();
      pTest->Release();
      return hr;
   }

   //
   // liberar as interfaces
   //
   pClassFactory->Release();
   pTest->Release();


   return S_OK;
}
