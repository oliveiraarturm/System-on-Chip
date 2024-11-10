#ifndef HUFFMAN_H
#define HUFFMAN_H

#define MAX_TREE_HT 100


struct MinHeapNode {
    int data;
    unsigned freq;
    struct MinHeapNode *left, *right;
};


struct MinHeap {
    unsigned size;
    unsigned capacity;
    struct MinHeapNode** array;
};


struct MinHeapNode* newNode(int data, unsigned freq);
struct MinHeap* createMinHeap(unsigned capacity);
void swapMinHeapNode(struct MinHeapNode** a, struct MinHeapNode** b);
void minHeapify(struct MinHeap* minHeap, int idx);
int isSizeOne(struct MinHeap* minHeap);
struct MinHeapNode* extractMin(struct MinHeap* minHeap);
void insertMinHeap(struct MinHeap* minHeap, struct MinHeapNode* minHeapNode);
void buildMinHeap(struct MinHeap* minHeap);
int isLeaf(struct MinHeapNode* root);
struct MinHeap* createAndBuildMinHeap(int data[], int freq[], int size);
struct MinHeapNode* buildHuffmanTree(int data[], int freq[], int size);
void printCodes(struct MinHeapNode* root, int arr[], int top);
void HuffmanCodes(int data[], int freq[], int size);

#endif // HUFFMAN_H
