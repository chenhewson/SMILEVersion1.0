#include "FerNNClassifier.h"
#include "mex.h"
//#define	conf	plhs[0]
#define thr_nn 0.65
#define ncc_thesame 0.95
using namespace cv;
using namespace std;
double FerNNClassifier::trainNN(const vector<cv::Mat>& nn_examples){
	printf("helloword99");//(chen)
  float conf,dummy;

  vector<int> y(nn_examples.size(),0);//v3����n��ֵΪi��Ԫ�ء�y����Ԫ�س�ʼ��Ϊ0
  printf("// %d\n",nn_examples.size());
  y[0]=1;
  printf("hello999");//(chen)
  vector<int> isin;
  for (int i=0;i<nn_examples.size();i++){                          //  For each example
      NNConf(nn_examples[i],isin,conf,dummy);                      //  Measure Relative similarity��������ͼ��Ƭ������ģ��֮���������ƶ�conf
      if (y[i]==1 && conf<=thr_nn){                                //    if y(i) == 1 && conf1 <= tld.model.thr_nn % 0.65��ǩ�������������������ƶ�С��0.65 ������Ϊ�䲻����ǰ��Ŀ�꣬Ҳ���Ƿ�������ˣ���ʱ��Ͱ����ӵ���������
          if (isin[1]<0){                                          //      if isnan(isin(2))
              pEx = vector<Mat>(1,nn_examples[i]);                 //        tld.pex = x(:,i);
              continue;                                            //        continue;
          }                                                        //      end
          //pEx.insert(pEx.begin()+isin[1],nn_examples[i]);        //      tld.pex = [tld.pex(:,1:isin(2)) x(:,i) tld.pex(:,isin(2)+1:end)]; % add to model
          pEx.push_back(nn_examples[i]);
      }                                                            //    end
      if(y[i]==0 && conf>0.5)                                      //  if y(i) == 0 && conf1 > 0.5
        nEx.push_back(nn_examples[i]);                             //    tld.nex = [tld.nex x(:,i)];
 
  }                                                                 //  end
  acum++;
  printf("%d. Trained NN examples: %d positive %d negative\n",acum,(int)pEx.size(),(int)nEx.size());
  return conf;
}                                                                  //  end
 
/**
 * ����nn������ĺ��ģ�����ĸ��ݾ��Ǹ������ƶȵ�ֵ���ֵ�
 * rsconf ���ƶ�
 * csconf �������ƶ�
 */

//������ƶȣ�����
void FerNNClassifier::NNConf(const Mat& example, vector<int>& isin,float& rsconf,float& csconf){
  /*Inputs:
   * -NN Patch
   * Outputs:
   * -Relative Similarity (rsconf), Conservative Similarity (csconf), In pos. set|Id pos set|In neg. set (isin)
   */
  isin=vector<int>(3,-1);
  if (pEx.empty()){ //if isempty(tld.pex) % IF positive examples in the model are not defined THEN everything is negative
      rsconf = 0.0; //    conf1 = zeros(1,size(x,2));
      csconf=0.0;
      return;
  }
  if (nEx.empty()){ //if isempty(tld.nex) % IF negative examples in the model are not defined THEN everything is positive
      rsconf = 1;   //    conf1 = ones(1,size(x,2));
      csconf=1;
      return;
  }
  Mat ncc(1,1,CV_32F);
  float nccP,csmaxP,maxP=0.0;
  bool anyP=false;
  int maxPidx,validatedPart = ceil(pEx.size()*valid);
  float nccN, maxN=0.0;
  bool anyN=false;
  for (int i=0;i<pEx.size();i++){
      matchTemplate(pEx[i],example,ncc,CV_TM_CCORR_NORMED);      // measure NCC to positive examples ��һ�����ƥ�䷨
      nccP=(((float*)ncc.data)[0]+1)*0.5;//������������������ƶ�
      if (nccP>ncc_thesame)
        anyP=true;
      if(nccP > maxP){
          maxP=nccP;
          maxPidx = i;
          if(i<validatedPart)
            csmaxP=maxP;
      }
  }
  for (int i=0;i<nEx.size();i++){
      matchTemplate(nEx[i],example,ncc,CV_TM_CCORR_NORMED);     //���㸺������������ƶ�
      nccN=(((float*)ncc.data)[0]+1)*0.5;
      if (nccN>ncc_thesame)
        anyN=true;
      if(nccN > maxN)
        maxN=nccN;
  }
  //set isin
  if (anyP) isin[0]=1;  //if he query patch is highly correlated with any positive patch in the model then it is considered to be one of them
  isin[1]=maxPidx;      //get the index of the maximall correlated positive patch
  if (anyN) isin[2]=1;  //if  the query patch is highly correlated with any negative patch in the model then it is considered to be one of them
  //Measure Relative Similarity������ƶ� = ��������������ƶ� / ����������������ƶ� + ��������������ƶȣ�
  float dN=1-maxN;
  float dP=1-maxP;
  rsconf = (float)dN/(dN+dP);
  //Measure Conservative Similarity
  dP = 1 - csmaxP;
  csconf =(float)dN / (dN + dP); //���ս��
}

/***************** Matתvector **********************/
/*template<typename _Tp>
vector<_Tp> convertMat2Vector(const Mat &mat)
{
	return (vector<_Tp>)(mat.reshape(1, 1));//ͨ�������䣬����תΪһ��
}*/

void mexFunction(int nlhs, mxArray *plhs[], //nlhs���������Ŀ��plhsָ�����������ָ��
				 int nrhs, const mxArray*prhs[])//nrhs���������Ŀ��prhsָ�����������ָ��
{
    FerNNClassifier classifier;
    //float *csconf= NULL;
    double *csconf=NULL;//double csconf1=0.0;
	//vector<Mat> image;
    //double *img; 
	mwSize M,N,n;
    M = mxGetM(prhs[0]);  //��þ�������
	N = mxGetN(prhs[0]);
    //printf(prhs[0].size());
   // img = mxGetPr(prhs[0]);
    n = mxGetNumberOfDimensions(prhs[0]); //���������ܵ�ά��
    uchar *imgData = NULL;
    int h = M;
    int w = N;
    cv::Mat imagefac(h, w, CV_8UC1);
    vector<cv::Mat> image;
   //  convertMat2Vector(image);
    if (mxIsUint8(prhs[0]) && n == 2)
    {
       imgData = (uchar*)mxGetPr(prhs[0]); //mxGetPr()��������һ��double*�͵�ָ�룬ָ�����ĵ�һ��Ԫ��
       int subs[2]; // ��ͨ��ͼ�����Ҫ subs [3], ������������Ӧ�޸�
 
        for (int i = 0; i < h; i++)
       {
            subs[0] = i;
            for (int j = 0; j < w; j++)
            {
                 subs[1] = j;
                 int index = (int)mxCalcSingleSubscript(prhs[0], 2, subs); 
                 imagefac.row(i).col(j).data[0] = imgData[index];
            }
       }
    }
    
    image.push_back(imagefac.clone());
   
    plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
    csconf=mxGetPr(plhs[0]);
    //plhs[0]=classifier.trainNN(image);
    *csconf=classifier.trainNN(image);
    mxSetPr(plhs[0], csconf);
    return;
}