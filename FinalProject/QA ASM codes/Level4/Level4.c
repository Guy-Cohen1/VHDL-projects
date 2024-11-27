
int arr1[8]={1,2,3,4,5,6,7,8};
int arr2[8]={8,7,6,5,4,3,2,1};
int res1[8], res2[8];

void main(){
	
	for(i=0; i<8; i++){
		res1[i] = arr2[i] + arr1[i];
		res2[i] = arr2[i] - arr1[i];
	}
	
	loop_forever;
}

