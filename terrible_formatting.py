class BadlyFormattedClass:
    def __init__(self, name: str, age: int, data: dict | None):
        self.name = name
        self.age = age
        if data is None:
            data = {}
        self.data = data

    def get_info(self) -> str:
        return f"Name: {self.name}, Age: {self.age}"

    def process_data(self, items: list[str]) -> dict[str, int]:
        result = {}
        for i in range(len(items)):
            if items[i] in result:
                result[items[i]] += 1
            else:
                result[items[i]] = 1
        return result


def badly_formatted_function(x, y, z=None):
    if z is None:
        z = []

    # This is a comment with bad spacing
    result = []
    for i in range(x):
        if i % 2 == 0:
            result.append(i * y)
        else:
            result.append(i + y)

    # More terrible formatting
    if len(result) > 5:
        return result[:5]
    else:
        return result


def another_messy_function():
    data = {"key1": "value1", "key2": "value2", "key3": {"nested": "data"}}

    processed = []
    for k, v in data.items():
        if isinstance(v, dict):
            for nested_k, nested_v in v.items():
                processed.append(f"{k}.{nested_k}={nested_v}")
        else:
            processed.append(f"{k}={v}")

    return processed


if __name__ == "__main__":
    obj = BadlyFormattedClass("John", 25)
    print(obj.get_info())

    items = ["apple", "banana", "apple", "cherry", "banana", "apple"]
    counts = obj.process_data(items)
    print(f"Counts: {counts}")

    numbers = badly_formatted_function(10, 3)
    print(f"Numbers: {numbers}")

    processed_data = another_messy_function()
    for item in processed_data:
        print(f"- {item}")
